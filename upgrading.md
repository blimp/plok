# Upgrade guide

## From 0.2.4 to 0.2.9
0.2.5 introduced the `QueuedTask` model. You'll need to remove 
`app/models/queued_task.rb` and `spec/factories/queued_tasks.rb`.

If you get errors of missing methods, or you otherwise know your project's
`QueuedTask` to have additional features, you'll have to extend Plok's 
`QueuedTask` with your own additions. See `readme.md` on how to do this.


## From 0.2.3 to 0.2.4
You need to add `Plok::Engine.load_spec_supports` to `spec/rails_helper.rb`,
somewhere before the `RSpec.configure` block.


## From 0.2.2 to 0.2.3
--
0.2.3 introduced the `Log` model. You'll need to remove `app/models/log.rb` and 
`spec/factories/logs.rb`.

If you get errors of missing methods, or you otherwise know your project's `Log` 
to have additional features, you'll have to extend Plok's `Log` with your own 
additions. See `readme.md` on how to do this.


## From 0.1.2 to 0.2.2
--
This version introduces the `catch_all#resolve` action that's mapped by 
`get '*path'` in the routes.rb file. If you already have this line, you can omit
it in favor of the one in Plok. If your project already has this controller 
action, see what overlap you have and use whatever suits your project.

Look at Reli's `Frontend::RedirectsLastResortController` for inspiration.
