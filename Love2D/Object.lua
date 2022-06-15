object = {}

function object.Construct(x, y)
  print("Base:Construct")
end
function object.OnCollisionBegin(_other)
  print("Player::OnCollisionBegin")
end
return object
