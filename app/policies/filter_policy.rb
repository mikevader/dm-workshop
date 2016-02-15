class FilterPolicy < ApplicationPolicy

  def create?
    user.admin? or user.player? or user.dm?
  end

  def index?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def update?
    return true if user.admin?

    user.filters.include? record
  end

  def destroy?
    return true if user.admin?

    user.filters.include? record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
