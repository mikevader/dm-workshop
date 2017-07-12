module SpellsHelper
  def print_modal_tag(name, search_param)
    content_tag(:div, class: 'modal fade', id: name, tabindex: '-1', role: 'dialog') do
      content_tag(:div, class: 'modal-dialog modal-sm', role: 'document') do
        content_tag(:div, class: 'modal-content') do
          form_tag(print_path, method: 'get', target: '_blank') do
            header = header(search_param)
            body = body(search_param)
            footer = footer(search_param)

            header.safe_concat(body).safe_concat(footer)
          end
        end
      end
    end
  end

  def header(_search_param)
    content_tag(:div, class: 'modal-header') do
      close_button = button_tag(type: 'button', class: 'close', data: {dismiss: 'modal', label: 'close'}) do
        content_tag(:span, 'aria-hidden' => 'true') do
          '&times;'.html_safe
        end
      end
      header_title = content_tag(:h4, class: 'modal-title') do
        'Print format'.html_safe
      end

      close_button.safe_concat(header_title)
    end
  end

  def body(search_param)
    content_tag(:div, class: 'modal-body') do
      hidden_field = hidden_field_tag(:search, search_param)

      options = content_tag(:div, class: 'form-group') do
        card_option = content_tag(:div, class: 'radio') do
          label_tag('card_layout', class: 'radio-inline') do
            radio_button_tag('layout', 'card_layout', true).safe_concat('Cards')
          end
        end
        detail_option = content_tag(:div, class: 'radio') do
          label_tag('detail_layout', class: 'radio-inline') do
            radio_button_tag('layout', 'detail_layout', false).safe_concat('Detailed')
          end
        end

        card_option.safe_concat(detail_option)
      end

      hidden_field.safe_concat(options)
    end
  end

  def footer(_search_param)
    content_tag(:div, class: 'modal-footer') do
      submit_tag('Print', class: 'btn btn-default')
    end
  end
end
