# Upgrade guide
## From 0.1.2 to 0.2.0
--
This version introduces the `catch_all#resolve` action that's mapped by 
`get '*path'` in the routes.rb file. If you already have this line, you can omit
it in favor of the one in Plok. If your project already has this controller 
action, see what overlap you have and use whatever suits your project.
