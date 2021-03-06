require 'spec_helper'

describe Piece do

  it {should belong_to :game}

  it 'will not accept only x value outside range' do
    test_piece = Piece.create(:x => 9, :y => 1)
    expect(test_piece.save).to eq(false)
  end
  it 'will accept x values 1-8' do
    test_piece = Piece.create({:x => 8, :y => 1})
    expect(test_piece.save).to eq(true)
  end

  it 'will accept only y values 1-8' do
    test_piece = Piece.create({:x => 1, :y => 10})
    expect(test_piece.save).to eq(false)
  end

  describe '.horizontal_obstruction?' do
    it 'will return false if there are no pieces in the way' do
      Piece.create(x:1, y:1, type:'Rook')
      expect(Piece.horizontal_obstruction?(1,1,8,1)).to eq(false)
    end
    it 'will return true if there are pieces in the way' do
      Piece.create(x:1, y:1, type:'Rook')
      Piece.create({:x => 4, :y => 1, :type => "Rook"})
      expect(Piece.horizontal_obstruction?(1,1,8,1)).to eq(true)
    end
    it 'will return true if there are pieces in the way going the other direction' do
      Piece.create(x:1, y:1, type:'Rook')
      Piece.create(:x => 4, :y => 1, :type => "Rook")
      expect(Piece.horizontal_obstruction?(8,1,1,1)).to eq(true)
    end
  end

  describe '.vertical_obstruction?' do
    it 'will return false if there are no pieces in the way' do
      Piece.create(x:1, y:8, type:'Rook')
      expect(Piece.vertical_obstruction?(1,8,1,1)).to eq(false)
    end
    it 'will return true if there are pieces in the way' do
      Piece.create(x:1, y:8, type:'Rook')
      Piece.create({:x => 1, :y => 4, :type => "Rook"})
      expect(Piece.vertical_obstruction?(1,8,1,1)).to eq(true)
    end
    it 'will return true if there are pieces in the way going the other direction' do
      Piece.create(x:1, y:1, type:'Rook')
      Piece.create(:x => 1, :y => 5, :type => "Rook")
      expect(Piece.vertical_obstruction?(1,1,1,8)).to eq(true)
    end
  end

  describe '.render' do
    it "will return the rook's html for a specific location" do
      Piece.create(x: 1, y: 1, type: "Rook", white: true)
      expect(Piece.render(1, 1)).to eq ("<span class='glyphicon glyphicon-tower yin'></span>")
    end
    it "will return the bishop's html for a specific location" do
      Bishop.create(x: 2, y: 2, white: false)
      expect(Piece.render(2, 2)).to eq ("<span class='glyphicon glyphicon-bishop'></span>")
    end
    it "will return empty string at empty location" do
      expect(Piece.render(8, 8)).to eq ("")
    end
  end

  describe '.diagonal_obstruction?' do
    it 'will return false if there are no pieces in the way' do
      Piece.create(:x => 5, :y => 5, :type => "Rook")
      expect(Piece.diagonal_obstruction?(1,1,3,3)).to eq(false)
    end
    it 'will return true if there are pieces in the way' do
      Piece.create(x: 2, y: 2, type: "Bishop")
      expect(Piece.diagonal_obstruction?(1,1,4,4)).to eq(true)
    end
    it 'will return true if there are pieces in the way other direction' do
      Piece.create(x: 2, y: 2, type: "Bishop")
      expect(Piece.diagonal_obstruction?(4,4,1,1)).to eq(true)
    end
    it 'will return true if there are pieces in the way other direction' do
      Piece.create(x: 4, y: 2, type: "Bishop")
      expect(Piece.diagonal_obstruction?(5,1,3,3)).to eq(true)
    end
  end

  describe '#space_available?' do
    it 'returns true if a space is ok to move to' do
      test_bishop = Bishop.create(x:1, y:1, white: true)
      Bishop.create(x:3, y:3, white: false)
      expect(test_bishop.space_available?(3,3)).to eq(true)
    end
  end

  describe "#move_it" do
    it "will change the location of the piece in the database" do
      rook1 = Rook.create(x: 8, y: 8, white: false)
      rook1.move_it(6,8)
      expect(rook1.x).to eq(6)
    end
  end

  describe '#promotion?' do
    it 'will recognize when a pawn has reached the end of the board' do
      piece1 = Piece.create(x:8, y:7, white: true, type: "Pawn")
      piece1.move_it(8,8)
      expect(piece1.promotion?).to eq(true)
    end

    it 'will recognize that a rook cannot be promoted' do
      piece1 = Piece.create(x:8, y:7, white: true, type: "Rook")
      piece1.move_it(8,8)
      expect(piece1.promotion?).to eq(false)
    end

    it 'will recognize that a pawn cannot (yet) be promoted' do
      piece1 = Piece.create(x:8, y:6, white: true, type: "Pawn")
      piece1.move_it(8,7)
      expect(piece1.promotion?).to eq(false)
    end
  end

  describe('#promote') do
    it 'will change the promote the pawn to a selected piece' do
      pawn1 = Piece.create(x:8, y:7, white: true)
      pawn1.move_it(8,8)
      pawn1.promote("Rook")
      expect(pawn1.type).to eq("Rook")
    end
  end



end
