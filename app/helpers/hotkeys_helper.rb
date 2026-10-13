module HotkeysHelper
  def hotkey_label(hotkey, size: 'sm')
    kbd_size = case size
               when 'xs' then 'kbd-xs'
               when 'sm' then 'kbd-sm'
               end

    klass = "shortcut-hint #{kbd_size} print:hidden hide-on-touch max-sm:hidden js-only"

    content_tag :span, class: "#{klass} text-#{size}" do
      if hotkey.is_a?(Array)
        hotkey.map do |key|
          tag.kbd(key.capitalize, class: "kbd #{kbd_size}")
        end.join('&nbsp;+&nbsp;').html_safe # rubocop:disable Rails/OutputSafety
      else
        tag.kbd(hotkey.capitalize, class: "kbd #{kbd_size}").html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end
end
