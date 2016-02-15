class MonsterPolicy < ApplicationPolicy

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

    user.monsters.include? record
  end

  def destroy?
    return true if user.admin?

    user.monsters.include? record
  end

  class Scope < Scope
    def resolve
      if user.nil?
        scope.where('shared = ?', true)
      elsif user.admin?
        scope.all
      else
        scope.where('shared = ? OR user_id = ?', true, user.id)
      end
    end
  end
end