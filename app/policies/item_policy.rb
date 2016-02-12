class ItemPolicy < ApplicationPolicy

  def create?
    user.admin?
  end

  def duplicate?
    create?
  end

  def index?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def preview?
    show?
  end

  def modal?
    show?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
