class UserPolicy < ApplicationPolicy
    def index?
        true
    end
    
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