class Queen < Piece

  def move? (new_x, new_y)
    if on_board?(new_x, new_y)
      if self.space_available?(new_x, new_y)
        if (new_x - self.x).abs == (new_y - self.y).abs #diagonal
          ! Piece.diagonal_obstruction?(self.x, self.y, new_x, new_y)
        elsif self.x == new_x #vertical
          ! Piece.vertical_obstruction?(self.x, self.y, new_x, new_y)
        elsif self.y == new_y #horizontal
          ! Piece.horizontal_obstruction?(self.x, self.y, new_x, new_y)
        else
          false
        end
      else
        false
      end
    else
      false
    end
  end

end
