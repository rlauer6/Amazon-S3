# Amazon::S3 2.1.1 Release Notes

## Overview

This release adds several new features including a command-line
interface, a bucket-emptying utility, flexible upload sources for
object uploads, improved JSON response handling, and a number of
bug fixes and documentation improvements.

## New Features

### Command-Line Interface

A new `amzn-s3-cli` command-line tool is included, implemented via
the new `Amazon::S3::CLI` module. It provides command-line access to
common bucket and object operations, including bucket policy, policy
status, and ACL inspection. It replaces the older `run-test.in`
development script.

### `empty_bucket` Method

`$s3->empty_bucket($bucket_name)` method deletes all object versions,
delete markers, and incomplete multipart uploads from a bucket in
batches. It returns a result hash with counts of items removed. This
method always raises an exception on error regardless of the
`raise_error` setting, and includes a count of items removed before
the failure in the error message.

**Warning:** This method permanently deletes all listed objects.
Use with caution.

### Flexible Upload Sources in `add_key`

`Amazon::S3::Bucket::add_key` now accepts a hash-reference
interface in addition to the traditional positional interface.
The new interface supports four upload source types:

- `data` — scalar content (existing behaviour)
- `filename` — path to a local file streamed directly
- `fh` — an open filehandle, staged to a temporary file
- `callback` — a code reference that yields chunks, staged to a
  temporary file

`add_key_filename` is now a thin wrapper around the `filename`
form of `add_key`.

Temporary files created for `fh` and `callback` uploads are
removed automatically after the upload completes or fails.

### JSON Response Decoding

Responses are now decoded with fallback logic: XML responses are
parsed as before; JSON responses (`application/json` or
`application/*+json`) are decoded using `JSON::PP`. If the declared
content type does not match the body, JSON decoding is attempted as a
fallback. Unrecognised successful response bodies are returned as raw
strings.

### `BucketV2` Operations

`Amazon::S3::BucketV2` adds generated methods for:

- `ListMultipartUploads` and `ListObjectVersions` (new list
  operations)
- `AbortMultipartUpload` (new delete operation)

A typo in the existing method name `put_object_lock_configuraiton`
has been corrected to `put_object_lock_configuration`.

## Improvements

### `endpoint_url` Handling

The `endpoint_url` option is now stored as an accessor and used to
suppress automatic host rewriting when the region changes. Passing
a full URL as the `host` option is still accepted but now emits a
deprecation warning; use `endpoint_url` instead.

### Test Infrastructure

- `S3TestUtils::set_s3_host` now accepts an explicit host argument
  and verifies that the LocalStack S3 service is actually running
  before tests proceed.
- `S3TestUtils::get_s3_service` now requires a host argument,
  propagates construction errors, and accepts a `raise_error`
  parameter.
- New integration tests: `t/11-empty-bucket.t`,
  `t/12-add-key-sources.t`, `t/13-response-decode.t`.
- A new `host as url` subtest covers the deprecated URL-as-host
  behaviour.

## Dependency Changes

### Required

- `CLI::Simple` >= 2.2.3
- `JSON::PP` >= 4.16
- `HTTP::Tiny` >= 0.088

### Suggested

- `File::MimeInfo::Magic` >= 0.37
- `Text::ASCIITable` >= 0.22 (replaces `Text::ASCIITable::EasyTable`)
- `Amazon::Credentials` >= 2.0.0

## Bug Fixes

- Fixed a potential mutation of the HTTP method in
  `BucketV2::create_methods`.
- Region rewriting no longer modifies the host when `endpoint_url`
  was supplied.
