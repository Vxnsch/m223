class PagePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user&.admin? || user&.uploader?
  end

  def new?
    create?
  end

  def destroy?
    user&.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user.present? ? scope.all : scope.none
    end
  end
end
