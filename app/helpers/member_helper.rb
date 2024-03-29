module MemberHelper
  def format_last_name_with_leader(member)
    if member.leader? == true
      "#{member.last_name} (leader)"
    else
      "#{member.last_name}"
    end
  end

  def format_first_name_with_leader(member)
    if member.leader? == true
      "#{member.first_name}*"
    else
      "#{member.first_name}"
    end
  end
end
