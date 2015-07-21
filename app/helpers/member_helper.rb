module MemberHelper
  def format_last_name_with_leader(member)
    if member.leader? == true
      "#{member.last_name} (leader)"
    else
      "#{member.last_name}"
    end
  end
end
