class SpellbookPolicy < ApplicationPolicy

  def create?
    !user.nil?
  end

  def index?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def update?
    return false if user.nil?
    return true if user.admin?

    user.spellbooks.include? record
  end

  def destroy?
    return false if user.nil?
    return true if user.admin?

    user.spellbooks.include? record
  end

  def select?
    !user.nil?
    user.spellbooks.include? record
  end

  def inscribe?
    !user.nil?
    user.spellbooks.include? record
  end

  def erase?
    !user.nil?
    user.spellbooks.include? record
  end

  def duplicate?
  end

  def modal?
  end

  def preview?
  end

  class Scope < Scope
    def resolve
      if user.nil?
        scope.none
      elsif user.admin?
        scope.all
      else
        scope.where('user_id = ?', user.id)
      end
    end
  end
end