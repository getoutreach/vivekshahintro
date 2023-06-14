local c = import 'concourse/pipeline.libsonnet';
local name = 'vivekshahintro';
local slackChannel = '';

// <<Stencil::Block(extraJsonnetImports)>>

// <</Stencil::Block>>

local repo = 'getoutreach/vivekshahintro';
local segments = import 'segments.libsonnet';

local pipeline = c.newPipeline(name=name, source_repo=repo, branch='main') {
  resource_types_: [{
    name: 'maestrov3',
    type: 'registry-image',
    source: {
      repository: 'gcr.io/outreach-docker/concourse/maestro-resource',
      tag: 'v3',
      username: $.gcr_registry_username,
      password: $.gcr_registry_password,
    },
  }],
  resources_: [
    $.maestroActionableVersion(name, segment.name)
    for segment in segments
  ] + [
    $.maestroDeployedVersion(name, segment.name)
    for segment in segments
    // <<Stencil::Block(extraResources)>>

    // <</Stencil::Block>>
  ],
  jobs_: [
    $.newJob('Deploy %s' % [segment.name], 'Deploy') {
      local maestroActionableName = 'maestro-%s-actionable_version' % [segment.name],
      local maestroDeployedName = 'maestro-%s-deployed_version' % [segment.name],
      local namespace = name + '--' + segment.name,
      steps:: [
        { get: 'source' },
        { get: maestroActionableName, trigger: true },
        $.checkoutMaestroVersion(maestroActionableName),
        $.deploymentStartSlackMessage(name, target=segment.name),
        $.k8sDeploy(
          debug=true,
          cluster_name=segment.cluster,
          namespace=namespace,
          manifests=['deployments/vivekshahintro/vivekshahintro.jsonnet'],
          kubecfg_vars={
            namespace: namespace,
            environment: segment.environment,
            bento: segment.name,
            channel: segment.channel,
            version: '$(cat %s/version)' % maestroActionableName,
            ts: '$(date +%s)',
            region: segment.region,
            appImageRegistry: 'gcr.io/outreach-docker',
          },
          vault_secrets=[
            // DEPRECATED: Use vaultSecrets instead in the `service.yaml`.
            //             THIS IS NOT COMPATIBLE WITH NGB
            // <<Stencil::Block(vaultSecrets)>>

            // <</Stencil::Block>>
          ],
          params={
            validation_retries: '1500',
          },
        ),
      ],
      plan_: $.steps(self.steps),
      on_success_: $.do(std.prune([
        {
          put: maestroDeployedName,
          params: {
            path: maestroActionableName,
          },
        },
        $.deploymentSuccessfulSlackMessage(name, target=segment.name),
        $.deploymentSuccessfulOpsLevelMessage(service=name, bento=segment.name, env=segment.environment),
      ])),
      on_failure_: $.do([
        $.deploymentFailedSlackMessage(name, target=segment.name),
      ]),
    }
    for segment in segments

    // If you need/want to change anything in here, please post in #dev or talk to a
    // CODEOWNER about it before modifying. :)   -The Management
  ] + [
    // <<Stencil::Block(extraJobs)>>

    // <</Stencil::Block>>
  ],
};

[pipeline]
