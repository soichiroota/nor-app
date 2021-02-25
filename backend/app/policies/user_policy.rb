class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
