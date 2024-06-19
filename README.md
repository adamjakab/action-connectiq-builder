# ConnectIQ Builder GitHub Actions

ConnectIQ Builder is a GitHub Action (`adamjakab/action-connectiq-builder@v1`) that can be used to test and build ConnectIQ applications.

## Usage

Basic usage would look something like this:

```yml
steps:
  # ... some other steps before ...
  - uses: actions/checkout@v4
  - name: Test my garmin app
    id: run_tests
    uses: adamjakab/action-connectiq-builder@v1
    with:
      operation: TEST
      device: fr235
  # ... some other steps after ...
```

### Inputs

The following inputs are available under the `with` keyword:

- `operation`: Required. [Default: TEST]. The main two operations you can chose between are:

  - `TEST` - will compile your application with the `--unit-test` flag and will run run those tests for the specified device. If any of the tests fail will cause the workflow to fail.
  - `PACKAGE` - **NOT YET IMPLEMENTED!** packages your application by running `monkeyc` with `--package-app` flag using the provided certificate. Once the package is created, it will be addded to a new release.
  - `INFO` - displays some information. Used for debugging purposes.

- `path`: Required. [Default: .] The path of the application to test. By default, the root of the repository will be used.

- `device`: Required. [Default: fr235] The id of the device used to run the operation. By default, a Forerunner 235 device is be used. The full list of devices can be found [here](https://developer.garmin.com/connect-iq/reference-guides/devices-reference/#devicereference).

- `check_type_level`: Required. [Default: 2] The type level check used when compiling the application with `monkeyc`. The available options (0-3) are described [here](https://developer.garmin.com/connect-iq/monkey-c/monkey-types/).

- `certificate`: Optional. The base64 encoded version of the certificate to be used to compile the applicat. If not specified, a temporary certificate will be used for the test operation. For build operation you should supply your own. Make sure to store it as a repository secret and add the variable name to your workflow.

### Outputs

- `status`: "success" if all tests are successful, "failure" if any of them fail.

## Notes

This acion relies on the docker image [ghcr.io/adamjakab/connectiq-builder](ghcr.io/adamjakab/connectiq-builder).
