module CommentsHelper
  def comment_rating_select_input
    values = Array.new(5) do |i|
      i += 1
      ["#{'⭐' * i} (#{i}/5)", i]
    end

    values.reverse
  end
end
