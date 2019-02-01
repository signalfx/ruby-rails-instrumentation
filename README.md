# Rails::Instrumentation

Instrumentation for Rails using ActiveSupport notifications.

## Supported versions

- Rails 5.2.x, 5.1.x, 5.0.x, 4.2.x

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-instrumentation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-instrumentation

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

## Instrumented Events

Events that have addition useful information in the payload will have additional
tags on their span, as listed below.

### Action Controller

| Event                                    | Payload Tags                                                                                                                                                   |
| ---                                      | ---                                                                                                                                                            |
| write_fragment.action_controller         | key.write                                                                                                                                                      |
| read_fragment.action_controller          | key.read                                                                                                                                                       |
| expire_fragment.action_controller        | key.expire                                                                                                                                                     |
| exist_fragment?.action_controller        | key.exist?                                                                                                                                                     |
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

| Event                         | Payload Tags                                                   |
| ---                           | ---                                                            |
| render_tempate.action_view    | template.identifier<br> template.layout                        |
| render_partial.action_view    | partial.identifier                                             |
| render_collection.action_view | template.identifier<br> template.count<br> template.cache_hits |

### Active Record

| Event                       | Payload Tags                                                 |
| ---                         | ---                                                          |
| sql.active_record           | db.statement<br> name<br> connection_id<br> binds<br> cached |
| instantiation.active_record | record.count<br> record.class                                |

### Active Support

| Event                          | Payload Tags                    |
| ---                            | ---                             |
| cache_read.active_support      | key<br> hit<br> super_operation |
| cache_generate.active_support  | key                             |
| cache_fetch_hit.active_support | key                             |
| cache_write.active_support     | key                             |
| cache_delete.active_support    | key                             |
| cache_exist?.active_support    | key                             |

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/signalfx/ruby-rails-instrumentation.
