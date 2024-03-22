enum VoteType {
  FOR,
  AGAINST,
}

VoteType? voteTypeFormString(String s) {
  if (s == VoteType.FOR.name) {
    return VoteType.FOR;
  } else if (s == VoteType.AGAINST.name) {
    return VoteType.AGAINST;
  } else {
    return null;
  }
}
