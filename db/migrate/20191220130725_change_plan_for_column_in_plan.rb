class ChangePlanForColumnInPlan < ActiveRecord::Migration[5.1]
  def change
    change_column(:beach_api_core_plans, :plan_for, :string)
  end
end
