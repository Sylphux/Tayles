class AddNodeToWorld < ActiveRecord::Migration[8.0]
  def change
    add_reference :worlds, :node, foreign_key: true
  end
end
