module ModalsHelper
  def render_modal(**, &block)
    modal_body_html = capture(&block) if block_given?
    render('application/modal', **, modal_body_html: modal_body_html)
  end
end
