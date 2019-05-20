# Changelog
All notable changes to olubalance will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] changes

## [v1.2.2] - 2019-05-19

### Fixed
- User registration issues have been fixed (#35)
- Transaction attachments will now be renamed to `{{trx_date}}_{{description}}.{{extension}}`

## [v1.2.1] - 2019-02-24

### Fixed
- Transaction attachments were not receiving the transaction ID in the filename. This has been corrected.
- Downgraded bundler to 1.16.2 due to deployment errors

## [v1.2.0] - 2019-02-24

### Added
- Accounts can be deactivated, which hides them from the main account list.  Inactive accounts can be found from the user menu and reactivated at any time.  This provides a non-destructive method of archiving an account for historical purposes. Deleting accounts is no longer possible from the UI.
- A new field has been added to allow storing the last 4 digits of the account number along with an account.  This can be helpful for quickly identifying an account by number.
- Transaction search based on the description field has been added.
- Account-level attachments have been added. An account may have many attachments. This is useful for storing account statements and correspondence in one location.
- Transaction autocomplete has been enabled in the description field. Autocomplete sources from a unique list of all transaction descriptions for the particular account.

### Changed
- Attachments for transactions are now renamed at upload to be formatted as `(trx_id)_(description)_(trx_date).(extension)`
- Attachment links will direct to an https URL
- Ruby version updated to 2.5.1
- Rails version updated to 5.2.2

### Fixed
- Account deletion removed, but deactivation will now deactivate the proper account.
- When editing a transaction on page N of the transaction list, after clicking update or cancel you will now be redirected back to page N instead of page 1.
- Account name should display better from the transaction list on mobile.

#### Gem Changes
- sass-rails gem replaced with sassc-rails
- pg gem updated to 1.1.4
- puma gem updated to 3.12.0
- aws-sdk gem replaced with aws-sdk-s3

[v1.2.0] will be the final feature release of olubalance as a pure Rails app. Going forward, olubalance will function as Rails API with a Vue.js frontend.

## [v1.1.3] - 2018-08-19
### Fixed
- Fixed issue with local user Time Zone. Users are now required to set their local timezone, and all dates within the application front end will reflect this timezone setting.

## [v1.1.2] - 2018-08-19
### Fixed
- Fixed issue with Transaction datepicker not loading

## [v1.1.1] - 2018-07-25
### Fixed
- Remove unnecessary devise controllers that were causing problems with deployment

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


[Unreleased]: https://github.com/odinsride/olubalance/compare/v1.2.2...HEAD
[v1.2.2]: https://github.com/odinsride/olubalance/compare/v1.2.1...v1.2.2
[v1.2.1]: https://github.com/odinsride/olubalance/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/odinsride/olubalance/compare/v1.1.3...v1.2.0
[v1.1.3]: https://github.com/odinsride/olubalance/compare/v1.1.2...v1.1.3
[v1.1.2]: https://github.com/odinsride/olubalance/compare/v1.1.1...v1.1.2
[v1.1.1]: https://github.com/odinsride/olubalance/compare/v1.1.0...v1.1.1
[v1.1.0]: https://github.com/odinsride/olubalance/compare/v1.0.2...v1.1.0
[v1.0.2]: https://github.com/odinsride/olubalance/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/odinsride/olubalance/compare/v1.0...v1.0.1