# Short URLs that redirects to SEO optimized pages
get '/asdb', to: redirect('/blogs/bank-exit-assembly-2025')
get '/:locale/asdb', to: redirect('/%{locale}/blogs/bank-exit-assembly-2025')
