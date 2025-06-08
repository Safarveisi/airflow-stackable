# s3cmd docker action

This action executes an arbitrary s3cmd command against a S3 bucket.

## Inputs

## `command`

**Required** The command to be execute by s3cmd (e.g., `'put'` or `'rm'`).

## `access_key`

**Required** The s3 bucket access key.

## `secret_key`

**Required** The s3 bucket secret access key.

## `host_base`

**Required**  The host base (endpoint url) for the s3-compatible service (e.g., `'s3.amazonaws.com'`).

##  `bucket_location`

**Required** Location of the s3 bucket (e.g., `'EU'`).

## Example usage

```yaml
uses: ./.github/actions/s3cmd-docker
with:
    command: put file.txt s3://bucket/prefix/file.txt
    access_key: access_key
    secret_key: secret_key
    host_base: host_base
    bucket_location: bucket_location
```
