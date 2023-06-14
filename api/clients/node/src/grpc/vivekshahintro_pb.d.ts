// package: vivekshahintro.api
// file: vivekshahintro.proto

/* tslint:disable */
/* eslint-disable */

import * as jspb from "google-protobuf";

export class PingRequest extends jspb.Message {
  getMessage(): string;
  setMessage(value: string): PingRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): PingRequest.AsObject;
  static toObject(
    includeInstance: boolean,
    msg: PingRequest
  ): PingRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {
    [key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>;
  };
  static serializeBinaryToWriter(
    message: PingRequest,
    writer: jspb.BinaryWriter
  ): void;
  static deserializeBinary(bytes: Uint8Array): PingRequest;
  static deserializeBinaryFromReader(
    message: PingRequest,
    reader: jspb.BinaryReader
  ): PingRequest;
}

export namespace PingRequest {
  export type AsObject = {
    message: string;
  };
}

export class PingResponse extends jspb.Message {
  getMessage(): string;
  setMessage(value: string): PingResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): PingResponse.AsObject;
  static toObject(
    includeInstance: boolean,
    msg: PingResponse
  ): PingResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {
    [key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>;
  };
  static serializeBinaryToWriter(
    message: PingResponse,
    writer: jspb.BinaryWriter
  ): void;
  static deserializeBinary(bytes: Uint8Array): PingResponse;
  static deserializeBinaryFromReader(
    message: PingResponse,
    reader: jspb.BinaryReader
  ): PingResponse;
}

export namespace PingResponse {
  export type AsObject = {
    message: string;
  };
}

export class PongRequest extends jspb.Message {
  getMessage(): string;
  setMessage(value: string): PongRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): PongRequest.AsObject;
  static toObject(
    includeInstance: boolean,
    msg: PongRequest
  ): PongRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {
    [key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>;
  };
  static serializeBinaryToWriter(
    message: PongRequest,
    writer: jspb.BinaryWriter
  ): void;
  static deserializeBinary(bytes: Uint8Array): PongRequest;
  static deserializeBinaryFromReader(
    message: PongRequest,
    reader: jspb.BinaryReader
  ): PongRequest;
}

export namespace PongRequest {
  export type AsObject = {
    message: string;
  };
}

export class PongResponse extends jspb.Message {
  getMessage(): string;
  setMessage(value: string): PongResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): PongResponse.AsObject;
  static toObject(
    includeInstance: boolean,
    msg: PongResponse
  ): PongResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {
    [key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>;
  };
  static serializeBinaryToWriter(
    message: PongResponse,
    writer: jspb.BinaryWriter
  ): void;
  static deserializeBinary(bytes: Uint8Array): PongResponse;
  static deserializeBinaryFromReader(
    message: PongResponse,
    reader: jspb.BinaryReader
  ): PongResponse;
}

export namespace PongResponse {
  export type AsObject = {
    message: string;
  };
}

export class JokeRequest extends jspb.Message {
  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): JokeRequest.AsObject;
  static toObject(
    includeInstance: boolean,
    msg: JokeRequest
  ): JokeRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {
    [key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>;
  };
  static serializeBinaryToWriter(
    message: JokeRequest,
    writer: jspb.BinaryWriter
  ): void;
  static deserializeBinary(bytes: Uint8Array): JokeRequest;
  static deserializeBinaryFromReader(
    message: JokeRequest,
    reader: jspb.BinaryReader
  ): JokeRequest;
}

export namespace JokeRequest {
  export type AsObject = {};
}

export class JokeResponse extends jspb.Message {
  getJoke(): string;
  setJoke(value: string): JokeResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): JokeResponse.AsObject;
  static toObject(
    includeInstance: boolean,
    msg: JokeResponse
  ): JokeResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {
    [key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>;
  };
  static serializeBinaryToWriter(
    message: JokeResponse,
    writer: jspb.BinaryWriter
  ): void;
  static deserializeBinary(bytes: Uint8Array): JokeResponse;
  static deserializeBinaryFromReader(
    message: JokeResponse,
    reader: jspb.BinaryReader
  ): JokeResponse;
}

export namespace JokeResponse {
  export type AsObject = {
    joke: string;
  };
}
