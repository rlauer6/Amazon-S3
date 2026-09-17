# Amazon::S3 2.1.0 Release Notes

## Overview

Version 2.1.0 is a significant release that adds modern S3 checksum
support for both uploads and downloads, improves error reporting,
strengthens the `Amazon::S3::BucketV2` interface, and migrates the build
system from Autoconf/Automake to a Make-based system using
`CPAN::Maker::Bootstrapper`.

## New Features

### Checksum Support

The headline feature of this release is integrated checksum handling
for S3 object transfers.

Upload checksums are now calculated and submitted automatically for
normal object uploads and high-level multipart uploads. The default
algorithm is `crc64nvme`, implemented locally by the new
`Digest::CRC64NVME` module included in this distribution.

Other locally supported algorithms include:

- `crc32`
- `crc32c`
- `md5`
- `sha1`
- `sha256`
- `sha512`

XXHash algorithms defined by S3 are recognized but are not yet
implemented locally.

The active upload algorithm is selected using the new
`checksum_algorithm` constructor option and accessor.
`upload_multipart_object()` applies the configured algorithm across all
parts of the multipart upload.

Download checksum verification is enabled by default through the new
`verify_checksums` accessor. When enabled, `Amazon::S3` requests
checksum metadata from S3 on GET operations and verifies supported
`FULL_OBJECT` checksums.

Verification is opportunistic. Downloads still succeed when S3 returns
no checksum or returns a checksum algorithm that is not implemented
locally. Partial or ranged downloads are not verified.

The `verify_checksums` setting controls download verification only and
does not affect upload checksum generation.

New constructor options:

- `checksum_algorithm`
- `verify_checksums`

New accessor:

- `checksum_types`, for introspection of locally available checksum
  implementations

### New Dependencies

`Digest::CRC` is now required for CRC64NVME and CRC32 checksum support.

`String::CRC32C` is now required for CRC32C checksum support.

## Build System Migration

The Autoconf/Automake build system has been replaced with a Make-based
system bootstrapped by `CPAN::Maker::Bootstrapper`.

Source files previously located under:

```text
src/main/perl/lib/
src/main/perl/t/
```

have been relocated to:

```text
lib/
t/
```

A `cpanfile` is now provided for dependency management.

The following build-system files and directories have been removed:

- `configure.ac`
- `bootstrap`
- `Makefile.am`
- `autotools/*.m4`
- `cpan/Makefile.am`
- the RPM spec template
- the `src/` directory hierarchy

## Bug Fixes and API Improvements

- Fixed a regexp in `_remember_errors` that was failing to capture the
  S3 error code correctly.

- `_croak_if_response_error` now includes the S3 error code and message
  in the exception string.

- Fixed a bug in `Amazon::S3::BucketV2::create_methods` that could allow
  an HTTP method override for one generated API method to affect methods
  generated later in the same loop.

- Generated `Amazon::S3::BucketV2` methods are now installed in the
  `Amazon::S3::BucketV2` namespace rather than being injected into
  `Amazon::S3::Bucket`.

- Request methods shared by `Amazon::S3` and the bucket classes have
  been renamed to remove the private-method prefix:

  * `_send_request` -> `send_request`
  * `_send_request_expect_nothing` -> `send_request_expect_nothing`
  * `_send_request_expect_nothing_probed` ->
    `send_request_expect_nothing_probed`

  These methods provide shared request infrastructure within the
  distribution; the rename reflects that they are not private to a
  single class.

## Error Handling and Endpoint Configuration

A new `raise_error` constructor option allows applications to request
exceptions for S3 request failures that historically returned a false
value and recorded details in `err`, `errstr`, and `error`.

`raise_error` defaults to false to preserve existing behavior. When
enabled, the error state is still recorded before the exception is
raised.

A new `endpoint_url` constructor option provides a simpler way to
configure alternate S3-compatible endpoints. For example:

```perl
endpoint_url => 'http://localhost:4566'
```

The URL determines both the service host and whether HTTP or HTTPS is
used. `endpoint_url` cannot be combined with `host` or `secure`.

## Documentation

The POD for `Amazon::S3`, `Amazon::S3::Bucket`, and
`Amazon::S3::BucketV2` has been substantially rewritten.

The `Amazon::S3` documentation now provides expanded coverage of:

- authentication and credentials
- checksum generation and verification
- bucket and object operations
- object listing and pagination
- multipart uploads
- directory buckets
- error handling
- logging
- S3-compatible services

`Amazon::S3::Bucket` has been reorganized primarily as a method
reference for the higher-level convenience bucket interface.

`Amazon::S3::BucketV2` has also been rewritten as a method reference
for additional S3 API operations not exposed directly by
`Amazon::S3::Bucket`. Its generated method names and request structure
are intended to closely follow the corresponding operations documented
by Amazon S3.

These additional API methods are available through
`Amazon::S3::BucketV2` objects created with `bucketv2()`.

The repository URL has changed to:

```text
https://github.com/rlauer6/Amazon-S3
```

## Test Suite

New test files include:

- `t/00-amazon-s3.t` - basic module load test
- `t/07-crc64nvme.t` - CRC64NVME implementation tests
- `t/08-checksums.t` - checksum generation and verification tests
- `t/09-bucket-v2.t` - generated method and request-construction tests
  for `Amazon::S3::BucketV2`
- `t/10-endpoint-url.t` - alternate endpoint configuration tests

Existing integration tests have been updated to use the new
`t/lib/` location for `S3TestUtils.pm`.

Test prerequisites now include:

- `Carp::Always`
- `HTTP::Headers`
- `HTTP::Response`
- `ReadOnly`
- `Test::Output`
- `XML::Simple`
