class FilterPolicy < ApplicationPolicy

  def create?
    user.admin?
  end

  def index?
    !user.nil?
  end

  def show?
    !user.nil?
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
