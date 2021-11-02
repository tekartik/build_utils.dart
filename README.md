# tekartik_build_utils

Build utils helper

## Usage

pubspec.yaml

```yaml
dev_dependencies:
  tekartik_build_utils:
    git: 
        url: https://github.com/tekartik/build_utils.dart
        ref: dart2_3
    version: '>=0.7.9'
```
 
A simple usage example:

    import 'package:tekartik_build_utils/common_import.dart';

    

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme

## Activation

### From git repository

    pub global activate -s git https://github.com/tekartik/build_utils.dart

### From local path

    pub global activate -s path .
    
## Development

    dartfmt --fix -w lib test example tool