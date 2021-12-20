>ℹ️&nbsp;&nbsp;SignalFx was acquired by Splunk in October 2019. See [Splunk SignalFx](https://www.splunk.com/en_us/investor-relations/acquisitions/signalfx.html) for more information.

# Rails::Instrumentation

OpenTracing instrumentation for Rails using ActiveSupport notifications. All events
currently instrumented by ActiveSupport are available to trace.

## Supported versions

- Rails 5.2.x, 5.1.x, 5.0.x, 4.2.x

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'signalfx-rails-instrumentation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install signalfx-rails-instrumentation

## Usage

```ruby
require 'rails/instrumentation'

tracer_impl = SomeTracerImplementation.new

Rails::Instrumentation.instrument(tracer: tracer,
                                  exclude_events: [])
```

`instrument` takes these optional named arguments:
- `tracer`: OpenTracing tracer to be used for this instrumentation
    - Default: `OpenTracing.global_tracer`
- `exclude_events`: Some events may be too noisy or they may simply not be
  necessary. These can be passed in as an array, and the instrumentation will
  not subscribe to those events. The available events can be found in the [Instrumented Events](#instrumented-events) section.
    - Default: `[]`
    - Example: `['sql.active_record', 'read_fragment.action_controller']`

All instrumentation can be removed:

```ruby
Rails::Instrumentation.uninstrument
```

This will clear all subscribers registered by this instrumentation.

## Instrumented Events

Events that have additional useful information in the payload will have additional
tags on their span, as listed below.

For more information about each event, please look at the ActiveSupport
notifications [documentation](https://guides.rubyonrails.org/active_support_instrumentation.html).

### Action Controller

| Event                                    | Span Tag Names                                                                                                                                                 |
| ---                                      | ---                                                                                                                                                            |
| write_fragment.action_controller         | key.write                                                                                                                                                      |
| read_fragment.action_controller          | key.read                                                                                                                                                       |
| expire_fragment.action_controller        | key.expire                                                                                                                                                     |
| exist_fragment?.action_controller        | key.exist                                                                                                                                                      |
| write_page.action_controller             | path.write                                                                                                                                                     |
| expire_page.action_controller            | path.expire                                                                                                                                                    |
| start_processing.action_controller       | controller<br> controller.action<br> request.params<br> request.format<br> http.method<br> http.url                                                            |
| process_action.action_controller         | controller<br> controller.action<br> request.params<br> request.format<br> http.method<br> http.url<br> http.status_code<br> view.runtime_ms<br> db.runtime_ms |
| send_file.action_controller              | path.send                                                                                                                                                      |
| send_data.action_controller              |                                                                                                                                                                |
| redirect_to.action_controller            | http.status_code<br> redirect.url                                                                                                                              |
| halted_callback.action_controller        | filter                                                                                                                                                         |
| unpermitted_parameters.action_controller | unpermitted_keys                                                                                                                                               |
### Action View

| Event                         | Span Tag Names                                                 |
| ---                           | ---                                                            |
| render_tempate.action_view    | template.identifier<br> template.layout                        |
| render_partial.action_view    | partial.identifier                                             |
| render_collection.action_view | template.identifier<br> template.count<br> template.cache_hits |

### Active Record

| Event                       | Span Tag Names                                               |
| ---                         | ---                                                          |
| sql.active_record           | db.statement<br> name<br> connection_id<br> binds<br> cached |
| instantiation.active_record | record.count<br> record.class                                |

### Action Mailer

| Event                 | Span Tag Names                                                                                                                             |
| ---                   | ---                                                                                                                                        |
| receive.action_mailer | mailer<br> message.id<br> message.subject<br> message.to<br> message.from<br> message.bcc<br> message.cc<br> message.date<br> message.body |
| deliver.action_mailer | mailer<br> message.id<br> message.subject<br> message.to<br> message.from<br> message.bcc<br> message.cc<br> message.date<br> message.body |
| process.action_mailer | mailer<br> action<br> args                                                                                                                 |

### Active Support

| Event                          | Span Tag Names                  |
| ---                            | ---                             |
| cache_read.active_support      | key<br> hit<br> super_operation |
| cache_generate.active_support  | key                             |
| cache_fetch_hit.active_support | key                             |
| cache_write.active_support     | key                             |
| cache_delete.active_support    | key                             |
| cache_exist?.active_support    | key                             |

### Active Job

| Event                    | Span Tag Names  |
| ---                      | ---             |
| enqueue_at.active_job    | adapter<br> job |
| enqueue.active_job       | adapter<br> job |
| perform_start.active_job | adapter<br> job |
| perform.active_job       | adapter<br> job |

### Action Cable

| Event                                           | Span Tag Names                     |
| ---                                             | ---                                |
| perform_action.action_cable                     | channel_class<br> action<br> data  |
| transmit.action_cable                           | channel_class<br> data<br> via     |
| transmit_subscription_confirmation.action_cable | channel_class                      |
| transmit_subscription_rejection.action_cable    | channel_class                      |
| broadcast.action_cable                          | broadcasting<br> message<br> coder |

### Active Storage

| Event                                     | Span Tag Names               |
| ---                                       | ---                          |
| service_upload.active_storage             | key<br> service<br> checksum |
| service_streaming_download.active_storage | key<br> service              |
| service_download.active_storage           | key<br> service              |
| service_delete.active_storage             | key<br> service              |
| service_delete_prefixed.active_storage    | key.prefix<br> service       |
| service_exist.active_storage              | key<br> service<br> exist    |
| service_url.active_storage                | key<br> service<br> url      |

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/signalfx/ruby-rails-instrumentation.
