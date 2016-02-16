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
