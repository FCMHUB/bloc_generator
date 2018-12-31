## 0.3.0

* Moved annotation inputs to Type from String where possible
* Added BLoCTemplate and Service abstract classes for type safety

## 0.2.6

* Add MapperService, AsyncMapperService, RequireMapperService and RequireAsyncMapperService

## 0.2.5

* Currect trigger types to Future\<void\> from void
* Make mappers optionally async

## 0.2.4

* Add TriggeredService

## 0.2.3

* Allow mappers to return null to not add anything to the output

## 0.2.2

* Added paramaters that can be passed to the BLoC and are accessible to BLoC services

## 0.2.1

* Make requiring a service require the service type
* Add BLoCService service that takes an entire BLoC instead of a Stream or Sink

## 0.2.0

* Make mappers async

## 0.1.9

* Make template value the only current value stored

## 0.1.8

* Moved value updater before calling mappers
* Updating latest values on template

## 0.1.7

* OutputService automatic listener
* OutputService automatic subscription disposer

## 0.1.6

* Remove current data from mappers

## 0.1.5

* Updated service documentation

## 0.1.4

* Changed Service to InputService and added OutputService
* Corrected name in README

## 0.1.3

* Fix README discrepencies

## 0.1.2

* Added documentation comments

## 0.1.1

* Fix library name
* Add example
* Format code

## 0.1.0

* Initial public release