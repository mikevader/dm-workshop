class SpellPolicy < ApplicationPolicy

  def create?
    user.admin? unless user.nil?
  end

  def duplicate?
    create?
  end

  def index?
    true
  end

  def show?
    true
  end

  def preview?
    show?
  end

  def modal?
    show?
  end

  def update?
    user.admin? unless user.nil?
  end

  def destroy?
    user.admin? unless user.nil?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
