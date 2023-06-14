
<!-- Space: https://outreach-io.atlassian.net/wiki/spaces/SP/overview?homepageId=2320568393 -->
<!-- Parent: Service Documentation 🧊 -->
<!-- Parent: vivekshahintro 🧊 -->
<!-- Title: vivekshahintro Disaster Recovery 🧊 -->

# Disaster Recovery

## Recovering from Kubernetes Resource Deletion

Like all bootstrap services, deployments are controlled via maestro/dash and either Concourse or ArgoCD
depending on the type of bento(s) it was deployed to. For legacy bentos, simply re-trigger a deployment
via Concourse and for next-gen bentos just wait for ArgoCD automatically redeploy it.

<!-- <<Stencil::Block(disasterRecovery)>> -->

<!-- <</Stencil::Block>> -->
