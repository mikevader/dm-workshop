require 'redcarpet'

module ApplicationHelper
  include Pagy::Frontend

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       autolink: true,
                                       lax_spacing: true,
                                       quote: true,
                                       footnotes: true,
                                       hard_wrap: true,
                                       safe_links_only: true)

    return markdown.render(text)
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Dungeon Masters Workshop'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def link_to_add_association(name, f, association, options={})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: "add_fields #{options[:class]}", "data-action": "attribute#add", data: {id: id, fields: fields.gsub("\n", '')})
  end

  def link_to_remove_association(_name, f, options={}, &block)
    js = "$('##{options[:id]}').parent().remove()"

    if block_given?
      content_tag('a', class: "remove_fields #{options[:class]}", onclick: js, &block)
    else
      content_tag('a', 'remove', nil, class: "remove_fields #{options[:class]}", onclick: js)
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', "data-action": "attribute#add", data: {id: id, fields: fields.gsub("\n", '')})
  end

  def link_to_remove_fields(_name, f)
    f.hidden_field(:_destroy)
    link_to 'remove', '#', class: 'remove_fields', "data-action": "attribute#remove"
  end
end
