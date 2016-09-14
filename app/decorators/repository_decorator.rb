class RepositoryDecorator < SimpleDelegator

  def display_name
    # self will refer to an instance of repo
    self.name.gsub("-", " ").titleize
  end
end