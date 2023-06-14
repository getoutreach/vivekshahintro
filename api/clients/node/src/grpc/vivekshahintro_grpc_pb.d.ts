// package: vivekshahintro.api
// file: vivekshahintro.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as vivekshahintro_pb from "./vivekshahintro_pb";

interface IVivekshahintroService
  extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
  ping: IVivekshahintroService_IPing;
  pong: IVivekshahintroService_IPong;
  joke: IVivekshahintroService_IJoke;
}

interface IVivekshahintroService_IPing
  extends grpc.MethodDefinition<
    vivekshahintro_pb.PingRequest,
    vivekshahintro_pb.PingResponse
  > {
  path: "/vivekshahintro.api.Vivekshahintro/Ping";
  requestStream: false;
  responseStream: false;
  requestSerialize: grpc.serialize<vivekshahintro_pb.PingRequest>;
  requestDeserialize: grpc.deserialize<vivekshahintro_pb.PingRequest>;
  responseSerialize: grpc.serialize<vivekshahintro_pb.PingResponse>;
  responseDeserialize: grpc.deserialize<vivekshahintro_pb.PingResponse>;
}
interface IVivekshahintroService_IPong
  extends grpc.MethodDefinition<
    vivekshahintro_pb.PongRequest,
    vivekshahintro_pb.PongResponse
  > {
  path: "/vivekshahintro.api.Vivekshahintro/Pong";
  requestStream: false;
  responseStream: false;
  requestSerialize: grpc.serialize<vivekshahintro_pb.PongRequest>;
  requestDeserialize: grpc.deserialize<vivekshahintro_pb.PongRequest>;
  responseSerialize: grpc.serialize<vivekshahintro_pb.PongResponse>;
  responseDeserialize: grpc.deserialize<vivekshahintro_pb.PongResponse>;
}
interface IVivekshahintroService_IJoke
  extends grpc.MethodDefinition<
    vivekshahintro_pb.JokeRequest,
    vivekshahintro_pb.JokeResponse
  > {
  path: "/vivekshahintro.api.Vivekshahintro/Joke";
  requestStream: false;
  responseStream: false;
  requestSerialize: grpc.serialize<vivekshahintro_pb.JokeRequest>;
  requestDeserialize: grpc.deserialize<vivekshahintro_pb.JokeRequest>;
  responseSerialize: grpc.serialize<vivekshahintro_pb.JokeResponse>;
  responseDeserialize: grpc.deserialize<vivekshahintro_pb.JokeResponse>;
}

export const VivekshahintroService: IVivekshahintroService;

export interface IVivekshahintroServer
  extends grpc.UntypedServiceImplementation {
  ping: grpc.handleUnaryCall<
    vivekshahintro_pb.PingRequest,
    vivekshahintro_pb.PingResponse
  >;
  pong: grpc.handleUnaryCall<
    vivekshahintro_pb.PongRequest,
    vivekshahintro_pb.PongResponse
  >;
  joke: grpc.handleUnaryCall<
    vivekshahintro_pb.JokeRequest,
    vivekshahintro_pb.JokeResponse
  >;
}

export interface IVivekshahintroClient {
  ping(
    request: vivekshahintro_pb.PingRequest,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PingResponse
    ) => void
  ): grpc.ClientUnaryCall;
  ping(
    request: vivekshahintro_pb.PingRequest,
    metadata: grpc.Metadata,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PingResponse
    ) => void
  ): grpc.ClientUnaryCall;
  ping(
    request: vivekshahintro_pb.PingRequest,
    metadata: grpc.Metadata,
    options: Partial<grpc.CallOptions>,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PingResponse
    ) => void
  ): grpc.ClientUnaryCall;
  pong(
    request: vivekshahintro_pb.PongRequest,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PongResponse
    ) => void
  ): grpc.ClientUnaryCall;
  pong(
    request: vivekshahintro_pb.PongRequest,
    metadata: grpc.Metadata,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PongResponse
    ) => void
  ): grpc.ClientUnaryCall;
  pong(
    request: vivekshahintro_pb.PongRequest,
    metadata: grpc.Metadata,
    options: Partial<grpc.CallOptions>,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PongResponse
    ) => void
  ): grpc.ClientUnaryCall;
  joke(
    request: vivekshahintro_pb.JokeRequest,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.JokeResponse
    ) => void
  ): grpc.ClientUnaryCall;
  joke(
    request: vivekshahintro_pb.JokeRequest,
    metadata: grpc.Metadata,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.JokeResponse
    ) => void
  ): grpc.ClientUnaryCall;
  joke(
    request: vivekshahintro_pb.JokeRequest,
    metadata: grpc.Metadata,
    options: Partial<grpc.CallOptions>,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.JokeResponse
    ) => void
  ): grpc.ClientUnaryCall;
}

export class VivekshahintroClient
  extends grpc.Client
  implements IVivekshahintroClient
{
  constructor(
    address: string,
    credentials: grpc.ChannelCredentials,
    options?: Partial<grpc.ClientOptions>
  );
  public ping(
    request: vivekshahintro_pb.PingRequest,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PingResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public ping(
    request: vivekshahintro_pb.PingRequest,
    metadata: grpc.Metadata,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PingResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public ping(
    request: vivekshahintro_pb.PingRequest,
    metadata: grpc.Metadata,
    options: Partial<grpc.CallOptions>,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PingResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public pong(
    request: vivekshahintro_pb.PongRequest,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PongResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public pong(
    request: vivekshahintro_pb.PongRequest,
    metadata: grpc.Metadata,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PongResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public pong(
    request: vivekshahintro_pb.PongRequest,
    metadata: grpc.Metadata,
    options: Partial<grpc.CallOptions>,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.PongResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public joke(
    request: vivekshahintro_pb.JokeRequest,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.JokeResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public joke(
    request: vivekshahintro_pb.JokeRequest,
    metadata: grpc.Metadata,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.JokeResponse
    ) => void
  ): grpc.ClientUnaryCall;
  public joke(
    request: vivekshahintro_pb.JokeRequest,
    metadata: grpc.Metadata,
    options: Partial<grpc.CallOptions>,
    callback: (
      error: grpc.ServiceError | null,
      response: vivekshahintro_pb.JokeResponse
    ) => void
  ): grpc.ClientUnaryCall;
}
