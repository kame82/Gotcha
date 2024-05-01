Rails.application.routes.draw do
  root 'staticpages#top'
  resource :pokemons
  get '/pokemons/noindex' => 'pokemons#noindex'
end
