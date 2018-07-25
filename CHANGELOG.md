# Changelog
All notable changes to olubalance will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] changes

## [v1.1.0] - 2018-07-24
### Added
- Major overhaul of the user interface using Material Design
- Better support for Mobile devices

### Changed
- Pagination looks nicer
- First and Last Name added to user registration

### Fixed
- Account starting balance is no longer changeable after creation


## [v1.0.2] - 2018-05-18
### Added
- Transactions can now have attachments! You can now save invoices or receipts alongside your transactions.  
- Attachments are stored on Amazon S3
- Images or PDF formats are supported.

## [v1.0.1] - 2018-04-07
### Fixed
- Corrected a typo on the homepage

## v1.0.0 - 2018-04-06
### Added
- olubalance 1.0.0 is our initial release which has basic functionality for users, such as
- User signup and login
- Create, edit, and delete accounts
- Create, edit, and delete transactions within each account
- Transaction table pagination (default 25 rows per page)
- Running balance calculated at the transaction level
- Account balance will be updated automatically after user operations on transactions
- Account overview with list of all accounts and balances for each


[Unreleased]: https://github.com/odinsride/olubalance/compare/v1.1.0...HEAD
[v1.1.0]: https://github.com/odinsride/olubalance/compare/v1.0.2...v1.1.0
[v1.0.2]: https://github.com/odinsride/olubalance/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/odinsride/olubalance/compare/v1.0...v1.0.1