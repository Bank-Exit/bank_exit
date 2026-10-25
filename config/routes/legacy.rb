# Redirect old static projects URL to the alias domain
# to avoid Rails router to swallow them and render 404.
# !!! Do not remove these URLs, they are mandatory for
# compatibilty purposes !!!
get '/cheque', to: redirect('https://monero-map.org/cheque/')
get '/crypto_box', to: redirect('https://monero-map.org/crypto_box/')
get '/epicerie', to: redirect('https://libre-market.com/m/epicerie')
get '/map.html', to: redirect('/en/map')
get '/c', to: redirect(QueryRedirector.new('https://monero-map.org/c/'))

# English
get '/en/accounting', to: redirect('/en/tutorials/accounting')
get '/en/merchants/new', to: redirect('/en/merchant_proposals/new')
get '/frequently-asked-questions', to: redirect('/en/faq')
get '/en/frequently-asked-questions', to: redirect('/en/faq')
get '/glossary', to: redirect('/en/glossaries')
get '/en/glossary', to: redirect('/en/glossaries')
get '/stats', to: redirect('/en/stats')
get '/map/embed', to: redirect(QueryRedirector.new('/en/map/embed'))

# French
get '/les-marchands/:id', to: redirect('/fr/merchants/%{id}')
get '/commercants/new', to: redirect('/fr/merchant_proposals/new')
get '/commercants/:id', to: redirect('/fr/merchants/%{id}')
get '/les-groupes-locaux', to: redirect('/fr/local_groups')
get '/groupes-locaux', to: redirect('/fr/local_groups')
get '/les-projets', to: redirect('/fr/projects')
get '/les-projets/:id', to: redirect('/fr/projects/%{id}')
get '/projets/:id', to: redirect('/fr/projects/%{id}')
get '/compta', to: redirect('/fr/tutorials/accounting')
get '/comptabilite', to: redirect('/fr/tutorials/accounting')
get '/tutoriels/accounting', to: redirect('/fr/tutorials/accounting')
get '/le-collectif', to: redirect('/fr/collective')
get '/glossaire', to: redirect('/fr/glossaries')
get '/annuaire', to: redirect('/fr/directories')
get '/risques', to: redirect('/fr/risks')
get '/foire-aux-questions', to: redirect('/fr/faq')
get '/tutoriels', to: redirect('/fr/tutorials')
get '/tutoriels/:id', to: redirect('/fr/tutorials/%{id}')

# Spanish
get '/es/los-comerciantes/:id', to: redirect('/es/merchants/%{id}')
get '/es/comerciantes/new', to: redirect('/es/merchant_proposals/new')
get '/es/comerciantes/:id', to: redirect('/es/merchants/%{id}')
get '/es/los-grupos-locales', to: redirect('/es/local_groups')
get '/es/grupos-locales', to: redirect('/es/local_groups')
get '/es/los-proyectos', to: redirect('/es/projects')
get '/es/los-proyectos/:id', to: redirect('/es/projects/%{id}')
get '/es/proyectos/:id', to: redirect('/es/projects/%{id}')
get '/es/contabilidad', to: redirect('/es/tutorials/accounting')
get '/es/contabilidad', to: redirect('/es/tutorials/accounting')
get '/es/tutoriales/accounting', to: redirect('/es/tutorials/accounting')
get '/es/el-colectivo', to: redirect('/es/collective')
get '/es/glosario', to: redirect('/es/glossaries')
get '/es/anuario', to: redirect('/es/directories')
get '/es/riesgos', to: redirect('/es/risks')
get '/es/preguntas-mas-frecuentes', to: redirect('/es/faq')

# Other old routes
get '/:locale/projects/accounting', to: redirect('/%{locale}/tutorials/accounting')
get '/:locale/blogs/flyer', to: redirect('/%{locale}/projects/flyer')
get '/:locale/projects/local_groups', to: redirect('/%{locale}/local_groups')
