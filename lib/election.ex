defmodule Election do
  defstruct(
    name: "Mayor",
    candidates: [
      Candidate.new(1, "Will Ferrel"),
      Candidate.new(2, "Kristen Wiig")
    ],
    next_id: 3
  )

  def update(election, command) when is_binary(command) do
    update(election, String.split(command))
  end

  # TODO: Refactor this function
  def update(election, ["v" <> _ | args]) do
    candidate_id =
      args
      |> Enum.join(" ")
      |> Integer.parse()
      |> elem(0)

    candidates =
      Enum.map(election.candidates, fn candidate ->
        if candidate.id == candidate_id do
          %{candidate | votes: candidate.votes + 1}
        else
          candidate
        end
      end)

    %{election | candidates: candidates}
  end

  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ")
    candidate = Candidate.new(election.next_id, name)

    %{
      election
      | next_id: election.next_id + 1,
        candidates: [candidate | election.candidates]
    }
  end

  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ")
    %{election | name: name}
  end

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end

  def view_header(election) do
    [
      "Election for: #{election.name}\n"
    ]
  end

  def view_body(election) do
    election.candidates
    |> sort_candidates_by_votes_desc()
    |> candidates_to_string()
    |> prepend_candidates_header()
  end

  def view_footer do
    [
      "\n",
      "commands: (n)ame <election>, (a)dd candidate, (v)ote id, (q)uit\n"
    ]
  end

  defp sort_candidates_by_votes_desc(candidates) do
    Enum.sort(candidates, &(&1.votes >= &2.votes))
  end

  defp candidates_to_string(candidates) do
    Enum.map(candidates, fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{votes}\t#{name}\n"
    end)
  end

  defp prepend_candidates_header(candidates) do
    [
      "ID\tVotes\tName\n",
      "--------------------------\n"
      | candidates
    ]
  end
end
