// GENERATED CODE -- DO NOT EDIT!

// Original file comments:
// Copyright 2023 Outreach Corporation. All Rights Reserved.
// Please modify this to match the interface specified in vivekshahintro.go
'use strict';
var grpc = require('@grpc/grpc-js');
var vivekshahintro_pb = require('./vivekshahintro_pb.js');

function serialize_vivekshahintro_api_JokeRequest(arg) {
  if (!(arg instanceof vivekshahintro_pb.JokeRequest)) {
    throw new Error('Expected argument of type vivekshahintro.api.JokeRequest');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_vivekshahintro_api_JokeRequest(buffer_arg) {
  return vivekshahintro_pb.JokeRequest.deserializeBinary(new Uint8Array(buffer_arg));
}

function serialize_vivekshahintro_api_JokeResponse(arg) {
  if (!(arg instanceof vivekshahintro_pb.JokeResponse)) {
    throw new Error('Expected argument of type vivekshahintro.api.JokeResponse');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_vivekshahintro_api_JokeResponse(buffer_arg) {
  return vivekshahintro_pb.JokeResponse.deserializeBinary(new Uint8Array(buffer_arg));
}

function serialize_vivekshahintro_api_PingRequest(arg) {
  if (!(arg instanceof vivekshahintro_pb.PingRequest)) {
    throw new Error('Expected argument of type vivekshahintro.api.PingRequest');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_vivekshahintro_api_PingRequest(buffer_arg) {
  return vivekshahintro_pb.PingRequest.deserializeBinary(new Uint8Array(buffer_arg));
}

function serialize_vivekshahintro_api_PingResponse(arg) {
  if (!(arg instanceof vivekshahintro_pb.PingResponse)) {
    throw new Error('Expected argument of type vivekshahintro.api.PingResponse');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_vivekshahintro_api_PingResponse(buffer_arg) {
  return vivekshahintro_pb.PingResponse.deserializeBinary(new Uint8Array(buffer_arg));
}

function serialize_vivekshahintro_api_PongRequest(arg) {
  if (!(arg instanceof vivekshahintro_pb.PongRequest)) {
    throw new Error('Expected argument of type vivekshahintro.api.PongRequest');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_vivekshahintro_api_PongRequest(buffer_arg) {
  return vivekshahintro_pb.PongRequest.deserializeBinary(new Uint8Array(buffer_arg));
}

function serialize_vivekshahintro_api_PongResponse(arg) {
  if (!(arg instanceof vivekshahintro_pb.PongResponse)) {
    throw new Error('Expected argument of type vivekshahintro.api.PongResponse');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_vivekshahintro_api_PongResponse(buffer_arg) {
  return vivekshahintro_pb.PongResponse.deserializeBinary(new Uint8Array(buffer_arg));
}


// Vivekshahintro is the vivekshahintro service.
var VivekshahintroService = exports.VivekshahintroService = {
  ping: {
    path: '/vivekshahintro.api.Vivekshahintro/Ping',
    requestStream: false,
    responseStream: false,
    requestType: vivekshahintro_pb.PingRequest,
    responseType: vivekshahintro_pb.PingResponse,
    requestSerialize: serialize_vivekshahintro_api_PingRequest,
    requestDeserialize: deserialize_vivekshahintro_api_PingRequest,
    responseSerialize: serialize_vivekshahintro_api_PingResponse,
    responseDeserialize: deserialize_vivekshahintro_api_PingResponse,
  },
  pong: {
    path: '/vivekshahintro.api.Vivekshahintro/Pong',
    requestStream: false,
    responseStream: false,
    requestType: vivekshahintro_pb.PongRequest,
    responseType: vivekshahintro_pb.PongResponse,
    requestSerialize: serialize_vivekshahintro_api_PongRequest,
    requestDeserialize: deserialize_vivekshahintro_api_PongRequest,
    responseSerialize: serialize_vivekshahintro_api_PongResponse,
    responseDeserialize: deserialize_vivekshahintro_api_PongResponse,
  },
  joke: {
    path: '/vivekshahintro.api.Vivekshahintro/Joke',
    requestStream: false,
    responseStream: false,
    requestType: vivekshahintro_pb.JokeRequest,
    responseType: vivekshahintro_pb.JokeResponse,
    requestSerialize: serialize_vivekshahintro_api_JokeRequest,
    requestDeserialize: deserialize_vivekshahintro_api_JokeRequest,
    responseSerialize: serialize_vivekshahintro_api_JokeResponse,
    responseDeserialize: deserialize_vivekshahintro_api_JokeResponse,
  },
};

exports.VivekshahintroClient = grpc.makeGenericClientConstructor(VivekshahintroService);
