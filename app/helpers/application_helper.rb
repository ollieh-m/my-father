module ApplicationHelper
  def render_if_exists(path, *options)
    render(path, *options)
  rescue ActionView::MissingTemplate
  end
end
