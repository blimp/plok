# Plok

## Backend sidebar navigation component
A `plok:sidebar` generator was added that'll copy over the necessary markup
files for a mobile-friendly sidebar component in your backend:

```bash
bin/rails g plok:sidebar
```

Note that it will only copy markup files so as to guarantee uniform
functionality across our backends, especially in regards to the JS. Meanwhile, 
custom changes or additions to the CSS should be made in supplementary files.

## Overriding models
You might want to add something to a Plok model at some point. As an example, 
let's override `Log`.

First, create a `config/initializers/plok.rb` file that contains the following:

```ruby
Rails.configuration.to_prepare do
  require Rails.root.join('app/models/log.rb')
end
```

Then create the model file referenced above, and use `class_eval` to override
it.
```ruby
Log.class_eval do
  mount_uploader :file, LogFileUploader

  def foo
    'bar'
  end
end
```

You'll be able to add to the model without removing any of its features. You
could also override any of its methods or scopes, if you know what you're doing.
