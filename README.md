# ConnectIQ Builder GitHub Actions

ConnectIQ Builder is a GitHub Action that can be used to test and build ConnectIQ applications. 


## Usage

Basic usage:

```
- name: Test application
  id: run_tests
  uses: adamjakab/action-connectiq-builder@v1
  with:
    device: fr235
```

### Inputs

- path: The path of the application to test. By default, the root of the repository will be used.
- device: The id of the device used to run the tests. By default, a Fenix 7 will be used.
- certificate: **!!!DO NOT USE!!!** The optional path of a certificate used to compile the application relatively to the path of the application. If not specified, a temporary certificate will be generated automatically.

### Outputs

- status: "success" if tests succeeded, "failure" if not


## Notes

This acion relies on the docker image [ghcr.io/adamjakab/connectiq-builder](ghcr.io/adamjakab/connectiq-builder).