# Test Report

## Command

`moon test`

## Relevant output

```text
/usr/bin/ld: cannot find -ltchproxy: No such file or directory
collect2: error: ld returned 1 exit status
```

## Analysis

The fallback test command reaches native linking but the local environment does
not provide `libtchproxy`. The repository's `torch/moon.pkg` links native tests
with `-ltchproxy`, so the failure is an unavailable external native dependency,
not a MoonBit source failure from this promotion.
