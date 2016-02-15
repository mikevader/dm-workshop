class CardPolicy < ApplicationPolicy

  def create?
    user.admin? or user.dm?
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
    return true if user.admin?

    user.cards.include? record
  end

  def destroy?
    return true if user.admin?

    user.cards.include? record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end