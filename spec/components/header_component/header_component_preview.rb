class HeaderComponent::HeaderComponentPreview < ViewComponent::Preview
  def default
    render(HeaderComponent::View.new(nil))
  end

  def with_user
    current_user = OpenStruct.new(name: "使用者")
    render(HeaderComponent::View.new(current_user))
  end
end
