pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	state={}
	init_demo()
end

function init_demo()
 state.score=100
 state.level=0
 state.lines=0
 state.time=0

 active_piece=new_piece(3,10,"i")
 state.active_piece=active_piece
 
 shape=random_shape("i")
 next_piece=new_piece(12,12,shape)
 state.next_piece=next_piece
 
 grid=new_grid()
 grid[12][3]=colors["grey"]
 grid[12][6]=colors["yellow"]
 grid[13][1]=colors["blue"]
 grid[13][2]=colors["grey"]
 grid[13][3]=colors["grey"]
 grid[13][6]=colors["yellow"]
 grid[13][7]=colors["yellow"]
 grid[13][9]=colors["pink"]
 grid[14][1]=colors["blue"]
 grid[14][2]=colors["grey"]
 grid[14][3]=colors["purple"]
 grid[14][4]=colors["purple"]
 grid[14][6]=colors["green"]
 grid[14][7]=colors["yellow"]
 grid[14][9]=colors["pink"]
 grid[15][1]=colors["blue"]
 grid[15][2]=colors["blue"]
 grid[15][3]=colors["purple"]
 grid[15][4]=colors["purple"]
 grid[15][5]=colors["green"]
 grid[15][6]=colors["green"]
 grid[15][7]=colors["green"]
 grid[15][8]=colors["pink"]
 grid[15][9]=colors["pink"]
 state.grid=grid
 
 state.phase="running"
end

-->8
function _update()
 if state.phase=="running" then
  state=update_game(state)
 end
end

function update_ap(state)
 local ap=state.active_piece
 if btnp(⬅️) then
  ap=move_left(ap,state.grid)
 elseif btnp(➡️) then
  ap=move_right(ap,state.grid)
 elseif btnp(⬇️) then
  ap=move_down(ap,state.grid)
 else
  ap=drop(state)
 end
 return ap
end

function update_game(state)
 local _state=state
 if collision(state.active_piece,state.grid,⬇️) then
  _state=update_pieces(state)
 else
  _state.active_piece=update_ap(state)
 end
 _state.time+=1
 return _state
end

function update_pieces(state)
 local _state=state

	local active_piece=new_piece(1,5,state.next_piece.shape)
 local next_shape=random_shape(_state.next_piece.shape)
 local next_piece=new_piece(12,12,next_shape)

 _state.grid=persist(_state.active_piece,_state.grid)
 _state.active_piece=active_piece
 _state.next_piece=next_piece
 
 return _state
end
-->8
function _draw()
 cls(0)
 draw_ui(state)
 draw_grid(state.grid)
 draw_piece(state.active_piece)
 draw_piece(state.next_piece)
end

function draw_block(row,col,clr)
 xs=8*(col-1)
 ys=8*row
 spr(clr,xs,ys)
end

function draw_grid(grid)
 for y,row in pairs(grid) do
  for x,c in pairs(row) do
   draw_block(y,x,c)
  end
 end
end

function draw_ui(state)
 print("score",88,17)
 print(state.score,88,25)

 print("level",88,41)
 print(state.level,88,49)
 
 local seconds=flr(state.time/30)
 print("time",88,65)
 print(seconds,88,73)
 
	print("next",88,89)
end

function draw_piece(p)
 for b in all(p) do
  draw_block(b.row,b.col,colors[b.clr])
 end
end


-->8
colors={
 blue=1,
 purple=2,
 green=3,
 brown=4,
 grey=5,
 yellow=6,
 pink=7,
 blank=8}

function collision(piece,grid,dir)
 for b in all(piece) do
  if dir==⬅️
   and grid[b.row][b.col-1]~=colors["blank"] then
    return true
  elseif dir==➡️
   and grid[b.row][b.col+1]~=colors["blank"] then
    return true
  elseif dir==⬇️
   and (b.row==15
 				  	or grid[b.row+1][b.col]~=colors["blank"]) then
    return true
  end
 end
 return false
end

function drop(state)
 local ap=state.active_piece
 if state.time%(30-state.level)==0
  and not collision(ap,state.grid,⬇️) then
  ap=move_down(ap,state.grid)
 end
 return ap
end

function move_down(piece,grid)
 local bottom=piece[1]
 for b in all(piece) do
  if b.row>bottom.row then
   bottom=b
  end
 end
 if bottom.row<15
  and not collision(piece,grid,⬇️) then
  for b in all(piece) do
   b.row+=1
  end
 end
 return piece
end

function move_left(piece,grid)
 local leftmost=piece[1]
 for b in all(piece) do
  if b.col<leftmost.col then
   leftmost=b
  end
 end
 if leftmost.col>1
  and not collision(piece,grid,⬅️) then
	  for b in all(piece) do
 	  b.col-=1
 	end
 end
 return piece
end

function move_right(piece,grid)
 local rightmost=piece[1]
 for b in all(piece) do
  if b.col>rightmost.col then
   rightmost=b
  end
 end
 if rightmost.col<10
  and not collision(piece,grid,➡️) then
  for b in all(piece) do
   b.col+=1
  end
 end
 return piece
end


function new_grid()
 grid={}
 for i=1,15 do
  grid[i]={}
  for j=1,10 do
   grid[i][j]=colors["blank"]
  end
 end
 return grid
end

function new_piece(row,col,shape)
 piece={shape=shape}
 if shape=="i" then
  piece[1]={row=row,col=col,clr="brown"}
  piece[2]={row=row+1,col=col,clr="brown"}
  piece[3]={row=row+2,col=col,clr="brown"}
  piece[4]={row=row+3,col=col,clr="brown"}
 elseif shape=="o" then
  piece[1]={row=row,col=col,clr="purple"}
  piece[2]={row=row,col=col+1,clr="purple"}
  piece[3]={row=row+1,col=col,clr="purple"}
  piece[4]={row=row+1,col=col+1,clr="purple"}
 elseif shape=="t" then
  piece[1]={row=row,col=col,clr="green"}
  piece[2]={row=row,col=col+1,clr="green"}
  piece[3]={row=row,col=col+2,clr="green"}
  piece[4]={row=row+1,col=col+1,clr="green"}
 elseif shape=="j" then
  piece[1]={row=row,col=col+1,clr="pink"}
  piece[2]={row=row+1,col=col+1,clr="pink"}
  piece[3]={row=row+2,col=col+1,clr="pink"}
  piece[4]={row=row+2,col=col,clr="pink"}
 elseif shape=="l" then
  piece[1]={row=row,col=col,clr="blue"}
  piece[2]={row=row+1,col=col,clr="blue"}
  piece[3]={row=row+2,col=col,clr="blue"}
  piece[4]={row=row+2,col=col+1,clr="blue"}
 elseif shape=="s" then
  piece[1]={row=row,col=col+2,clr="yellow"}
  piece[2]={row=row,col=col+1,clr="yellow"}
  piece[3]={row=row+1,col=col+1,clr="yellow"}
  piece[4]={row=row+1,col=col,clr="yellow"}
 elseif shape=="z" then
  piece[1]={row=row,col=col,clr="grey"}
  piece[2]={row=row,col=col+1,clr="grey"}
  piece[3]={row=row+1,col=col+1,clr="grey"}
  piece[4]={row=row+1,col=col+2,clr="grey"}
 end
 return piece
end

function persist(piece,grid)
 local _grid=grid
 for b in all(piece) do
  _grid[b.row][b.col]=colors[b.clr]
 end
 return _grid
end

function random_shape(curr_shape)
 new_shape=curr_shape
 repeat
  --[[
  note: generating new pieces
  should follow a well-balanced
  random distribution. the 'i'
  should be the rarest, given
  its importance for the game.
  --]] 
  new_shape=rnd({
   "i",
   "o","o",
   "t","t",
   "j","j",
   "l","l",
   "s","s","s",
   "z","z","z",
  })
 until new_shape~=curr_shape
 return new_shape
end
__gfx__
000000000111111002222220033333300444444005555550099999900eeeeee00000000000000000000000000000000000000000000000000000000000000000
00000000177cccc1277eeee2377bbbb34774444457766665977aaaa9e77ffffe0055550000000000000000000000000000000000000000000000000000000000
007007001771c1c1277222e237733bb34779994457755665977999a9e77ffffe0500005000000000000000000000000000000000000000000000000000000000
000770001c1c1cc12e2ee2e23b3bb3b344999944565555659a9999a9effeeffe0500005000000000000000000000000000000000000000000000000000000000
000770001cc1c1c12e2ee2e23b3bb3b344999944565555659a9999a9effeeffe0500005000000000000000000000000000000000000000000000000000000000
007007001c1c1cc12e2222e23bb33bb344999944566556659a9999a9effffffe0500005000000000000000000000000000000000000000000000000000000000
000000001cccccc12eeeeee23bbbbbb344444444566666659aaaaaa9effffffe0055550000000000000000000000000000000000000000000000000000000000
000000000111111002222220033333300444444005555550099999900eeeeee00000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047744444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047799944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047744444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047799944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047744444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047799944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047744444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000047799944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000555555000000000000000000999999000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000577666650000000000000000977aaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000577556650000000000000000977999a900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005655556500000000000000009a9999a900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005655556500000000000000009a9999a900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005665566500000000000000009a9999a900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005666666500000000000000009aaaaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000555555000000000000000000999999000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110055555500555555000000000000000000999999009999990000000000eeeeee000000000000000000000000000000000000000000000000000000000
177cccc157766665577666650000000000000000977aaaa9977aaaa900000000e77ffffe00000000000000000000000000000000000000000000000000000000
1771c1c157755665577556650000000000000000977999a9977999a900000000e77ffffe00000000000000000000000000000000000000000000000000000000
1c1c1cc1565555655655556500000000000000009a9999a99a9999a900000000effeeffe00000000000000000000000000000000000000000000000000000000
1cc1c1c1565555655655556500000000000000009a9999a99a9999a900000000effeeffe00000000000000000000000000000000000000000000000000000000
1c1c1cc1566556655665566500000000000000009a9999a99a9999a900000000effffffe00000000000000000000000000000000000000000000000000000000
1cccccc1566666655666666500000000000000009aaaaaa99aaaaaa900000000effffffe00000000000000000000000000000000000000000000000000000000
01111110055555500555555000000000000000000999999009999990000000000eeeeee000000000000000000000000000000000000000000000000000000000
01111110055555500222222002222220000000000333333009999990000000000eeeeee000000000000000000000000000000000000000000000000000000000
177cccc157766665277eeee2277eeee200000000377bbbb3977aaaa900000000e77ffffe00000000000000000000000000000000000000000000000000000000
1771c1c157755665277222e2277222e20000000037733bb3977999a900000000e77ffffe00000000000000000000000000000000000000000000000000000000
1c1c1cc1565555652e2ee2e22e2ee2e2000000003b3bb3b39a9999a900000000effeeffe00000000000000000000000000000000000000000000000000000000
1cc1c1c1565555652e2ee2e22e2ee2e2000000003b3bb3b39a9999a900000000effeeffe00000000000000000000000000000000000000000000000000000000
1c1c1cc1566556652e2222e22e2222e2000000003bb33bb39a9999a900000000effffffe00000000000000000000000000000000000000000000000000000000
1cccccc1566666652eeeeee22eeeeee2000000003bbbbbb39aaaaaa900000000effffffe00000000000000000000000000000000000000000000000000000000
01111110055555500222222002222220000000000333333009999990000000000eeeeee000000000000000000000000000000000000000000000000000000000
011111100111111002222220022222200333333003333330033333300eeeeee00eeeeee000000000000000000000000000000000000000000000000000000000
177cccc1177cccc1277eeee2277eeee2377bbbb3377bbbb3377bbbb3e77ffffee77ffffe00000000000000000000000000000000000000000000000000000000
1771c1c11771c1c1277222e2277222e237733bb337733bb337733bb3e77ffffee77ffffe00000000000000000000000000000000000000000000000000000000
1c1c1cc11c1c1cc12e2ee2e22e2ee2e23b3bb3b33b3bb3b33b3bb3b3effeeffeeffeeffe00000000000000000000000000000000000000000000000000000000
1cc1c1c11cc1c1c12e2ee2e22e2ee2e23b3bb3b33b3bb3b33b3bb3b3effeeffeeffeeffe00000000000000000000000000000000000000000000000000000000
1c1c1cc11c1c1cc12e2222e22e2222e23bb33bb33bb33bb33bb33bb3effffffeeffffffe00000000000000000000000000000000000000000000000000000000
1cccccc11cccccc12eeeeee22eeeeee23bbbbbb33bbbbbb33bbbbbb3effffffeeffffffe00000000000000000000000000000000000000000000000000000000
011111100111111002222220022222200333333003333330033333300eeeeee00eeeeee000000000000000000000000000000000000000000000000000000000

__map__
0000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
