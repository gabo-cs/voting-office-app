defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

  setup do
    %{election: %Election{}}
  end

  test "updates the election name from a command", ctx do
    election = Election.update(ctx.election, "n Sisa Mayor")
    assert election == %Election{name: "Sisa Mayor"}
  end

  test "adds a new candidate from a command", ctx do
    election = Election.update(ctx.election, "a Zohan Dvir")

    expected_election =
      %Election{
        candidates: [Candidate.new(1, "Zohan Dvir")],
        next_id: 2
      }

    assert election == expected_election
  end

  test "votes for a candidate from a command", ctx do
    election =
      ctx.election
      |> Election.update("a Zohan Dvir")
      |> Election.update("v 1")

    expected_election = %Election{
      candidates: [
        %Candidate{id: 1, name: "Zohan Dvir", votes: 1}
      ],
      next_id: 2
    }

    assert election == expected_election
  end

  test "quits the app", ctx do
    assert Election.update(ctx.election, "q") == :quit
  end

  test "ignores invalid command", ctx do
    assert Election.update(ctx.election, "sup!") == ctx.election
  end
end
