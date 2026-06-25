## [Unreleased]

- Add configurable HTTP timeouts (`config.open_timeout` / `config.timeout`, in seconds, passed to Faraday). Default `nil` (no timeout) keeps existing behavior; set them to fail fast instead of blocking when the API is slow.
- Add debug option

## [0.1.0] - 2023-10-27

- Initial release
