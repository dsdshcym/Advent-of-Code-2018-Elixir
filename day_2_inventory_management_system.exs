defmodule Inventory do
  def checksum(ids) do
    containing_two_same_letters(ids) * containing_three_same_letters(ids)
  end

  defp containing_two_same_letters(ids) do
    ids
    |> Enum.count(fn
      id ->
        id
        |> Enum.group_by(& &1)
        |> Enum.any?(fn {_, letters} -> length(letters) == 2 end)
    end)
  end

  defp containing_three_same_letters(ids) do
    ids
    |> Enum.count(fn
      id ->
        id
        |> Enum.group_by(& &1)
        |> Enum.any?(fn {_, letters} -> length(letters) == 3 end)
    end)
  end
end

ExUnit.start()

defmodule InventoryTest do
  use ExUnit.Case

  @input """
  qcsnyvpigkxmrdawlfdefotxbh
  qcsnyvligkymrdawljujfotxbh
  qmsnyvpigkzmrnawzjuefotxbh
  qosnyvpigkzmrnawljuefouxbh
  qcsnhlpigkzmrtawljuefotxbh
  qcsnyvpigkzmrdapljuyfotxih
  qcsnbvpiokzmrdawljuerotxbh
  qcfnyvmigkzmrdawljuefotdbh
  qcsnynpigkzmrdawljuefptxbp
  qcsgyapigkzmrdawljuafotxbh
  qcsnyvpigkzmrdapljueeotibh
  qcfnyvpigkzmndawljuwfotxbh
  qzsayvpigkzmrdawijuefotxbh
  qcsnsvpiekzmrdawljfefotxbh
  ncsnyvpigkzmrdaaljuefotxzh
  qssnyvpigkzmrdawljuefotobg
  qcshyipigkzmrdajljuefotxbh
  qcsnyvtigkzmrdawljgeaotxbh
  qcsnkvpxgkzmrdawljuefltxbh
  qcsnyvpiikzmrdawljuwfoqxbh
  qcsnybpigwzmqdawljuefotxbh
  qcsiyvpipkzbrdawljuefotxbh
  qldnyvpigkzmrdzwljuefotxbh
  qcsnyvpwgkzcrdawljuefmtxbh
  qcsnyvnigkzmrdahmjuefotxbh
  qcsnydpigkzmrdazljuefotxnh
  qcsqyvavgkzmrdawljuefotxbh
  ucsnyvpigkzmrdawljuefocxwh
  qcsnivpigrzmrdawljuefouxbh
  tcsnyvpibkzmrdawlkuefotxbh
  qcstytpigkzmrdawsjuefotxbh
  qcynyvpigkzmrdawlluefotjbh
  qcstyvpigkqrrdawljuefotxbh
  icsnyvpizkzmrcawljuefotxbh
  qcsnyvpimkzmrdavljuezotxbh
  qvsnoupigkzmrdawljuefotxbh
  qcsnyvpigkzmrdawwjuefftxgh
  qcpnyvpijkzmrdvwljuefotxbh
  qcsnyvpigkzmxdakdjuefotxbh
  jcsvyvpigkqmrdawljuefotxbh
  qcwnyvpigczmrsawljuefotxbh
  qcsnyvpdgkzmrdawljuefoixbm
  qysnyvpigkzmrdmwljuefotxbp
  qcsnavpigkzmrdaxajuefotxbh
  qcsfkvpigkzmrdawlcuefotxbh
  qcsnyvpigkvmrdawljcefotpbh
  qcsnyvpiqkkmrdawlvuefotxbh
  qhsnyvpigkzmrdawnjuedotxbh
  qasnlvpigkzmrdawljuefotxkh
  qgsnyvpigkzmrdabpjuefotxbh
  jcsnyvdigkzmrmawljuefotxbh
  qcsnivpigkzmrdawljuefonxth
  qcsnyjpigkzmrdawljgefotxmh
  qcstyvpigkzmrdacljuefovxbh
  qcsnvvpigkzmrdawljuewotrbh
  qcsnyvaigdzmrdawljueuotxbh
  qcsnyvpegkzmwdawljzefotxbh
  qcsnevpngkzmrdawlouefotxbh
  qcsnuvpigozmrdawljuefotdbh
  qgsnyvpigkzmqdayljuefotxbh
  qcsnyvpigkzmrdcwdjuofotxbh
  qcnnyvpigkzmrzawljuefstxbh
  qlsgyvpigkzmrdtwljuefotxbh
  qcsnyfpigkzlroawljuefotxbh
  qcsnkvwigkzmrdowljuefotxbh
  qcsnrvpigkzmrdawljuvfltxbh
  qcsnyvpigkzvreawljuefotxmh
  qcsrgvpigkzmrdawliuefotxbh
  qysnyvpigkzmrdawlxaefotxbh
  qcsnyvpigizmrdlwljuefotxbi
  qzsnyvpitkzmrdawljuefbtxbh
  qzgnyvpigkzmrdawljuefotxih
  qcsnyvpigkzmrdawlguefvtxbb
  qcsnyvpigkzmidawljuefouxjh
  qksnyvpigkzmrdawlruefotxhh
  qcsnyvpinkzmrdaaljuefotxah
  qcsnxvpigkzjrdawljuefhtxbh
  qcsnyvpigkzardawlgueuotxbh
  qcsnyvpiakzmrdpwljuefotxbt
  qcsnyvpigkzmrdawkjuefotxgb
  qcsnyvpigkzmrdawljuehocsbh
  qcsnsvpigktmrdawljuefotxvh
  qusnrvpigkzrrdawljuefotxbh
  qcsnyhiigkzmrdawrjuefotxbh
  qcsnavpigkzmrdawlfuefotxbz
  qcsnyvpigkzmmdamsjuefotxbh
  qcsnyvzigkzmrdcwljmefotxbh
  qcsnyvpigkzmriawljuefotbbe
  qcsnyvpigksmrdawljaefotxbd
  qcsnyvpigkzfrdawljuefoxxmh
  qcsnyvpygkrmrdawljuefotxbi
  qcsngvwigfzmrdawljuefotxbh
  qcsnyvpigkmkrdauljuefotxbh
  qcsnyvpigxzmrdgwljuefwtxbh
  qconyapigkzmrdaxljuefotxbh
  qcsnydpigkzwrdawljulfotxbh
  qcsnyvpimkzmmdawljuefotxch
  qcsnkspigkzmrdawgjuefotxbh
  qcsnyvpigkzmrdhwljfefbtxbh
  qcsnyipijkztrdawljuefotxbh
  qcseyvpigkrhrdawljuefotxbh
  qcsnyvpivkzmrdawljuefottbb
  qcsnyvpigkzmrdawlouefcjxbh
  qcsnyvpigkzmrgayljuefotxbm
  qcsnyvpvgkzmrdawrjujfotxbh
  qcsnyvpigkzmndawljuefqtxch
  qcsnyvpigbzmrdawljuefotibg
  qcsnyvpigkzmseawljuefotxbv
  qcsnwvpigkzmraawnjuefotxbh
  mcsnyvpiqkzmrdawljuefotlbh
  bcsnyvpigczmrdmwljuefotxbh
  qcsnyvpigkzmrtawljuegntxbh
  qcsnyvpijkzmrdawlmrefotxbh
  qdsnyvpfgkzmrdawljuekotxbh
  qcsnyvpigkzmrdawcjfegotxbh
  qcslyvphgkrmddawljuefotxbh
  qcsnyvpigkzmsdawkjuefojxbh
  qzsnyvpigkzmrzawljuefmtxbh
  qcsnyvpqgkzmcdawljuefttxbh
  qcsnyvpbgkpmrdawljuefoqxbh
  qcsnyvpigkemrdywljmefotxbh
  qcsnyypigkzmrdawljmefotxwh
  jcsnyvhwgkzmrdawljuefotxbh
  qcsnyvpigkzmrdawljurlotxwh
  qcsnnvpigzzmrdawljuefotwbh
  hcsnyvpigkzmrdarljuefitxbh
  qcsnyvpilkzmrfawljuefotsbh
  qcsnynpigkzmldawijuefotxbh
  qcsnyvpkgkjmrdawljuefotxlh
  qcsnylpigkzprdawljgefotxbh
  qcsnyvpigkzmrrawljnefohxbh
  qcsnivpigkzmrqawlbuefotxbh
  qcsgyvpigkzmrfawljuefotbbh
  qccuyvpigkzmrdawyjuefotxbh
  gcsnyvpigkzjrdawljuefotxby
  qcsmyvpiekzbrdawljuefotxbh
  qcsnyvpzgkrmrdawljuefotxbs
  qesnyvpigkzmpdqwljuefotxbh
  qcsnyvpigqzmrdawljuefutibh
  qcdnyvpigkzirdawljfefotxbh
  qcsnyvpiukzmrcrwljuefotxbh
  qcsnbvpickzmrdswljuefotxbh
  qcsnyvpighzmrpadljuefotxbh
  qccnyvpigkzmrdawljudxotxbh
  qcsnyvpigkzmrdabljuesotxlh
  qcsnyvpigkzmrrawlruefozxbh
  qconyzpigkzmrdawljuefotjbh
  qclnyvpigkzmrdxwljuefotbbh
  qcsnygpigkzmrdawlhuefooxbh
  qcsnyvpigkzmvdawljuefntxnh
  qcskyvpigkzmreawljuefotubh
  qrsnyvpxgkzmrdawljuefotxbz
  qclnyvpigtamrdawljuefotxbh
  qcsnyvpigkzmrdawojxefoyxbh
  qcsnyvpinkzmrdakljuwfotxbh
  qcsnyvpiykzmedawljuefgtxbh
  qcsayvpigkcmrdawijuefotxbh
  qcsnyvuiekzmrdamljuefotxbh
  qcdnyvpigkzmrdawnjuefoxxbh
  qcsnfvpwgszmrdawljuefotxbh
  qcsnycpigkzmrdawljqefotxih
  qcslyvphgkrmrdawljuefotxbh
  ecsnyvpigkzmrdawykuefotxbh
  qcsayvpigkzmraawljuekotxbh
  qcsnyvpigkdmrdawljuewofxbh
  qcznyvpigkzqrdawljuefotxnh
  qcsnyvplgkzmrdawljiefotlbh
  qcsnyvpigkzmroewljuefotbbh
  qcvnyvpigkzvrdawujuefotxbh
  qcanyypigkzmrdaeljuefotxbh
  qcsnyvwigkzmrdewljuefotxqh
  qcsryvpigkvmrdawljuefotabh
  pcsnyvpigkwmrdawljueforxbh
  qcsncvpigkzmrdawljuefotwmh
  qcsnyvpigozmrdawljudfozxbh
  qcsnynpigkzmrbawhjuefotxbh
  qcsnyvuigkzmrqawljuefotxch
  qcsnyvpickzmrdawljueeofxbh
  qcsnyvpigkzgrdawljueiouxbh
  qcsnyvpigkztrdawljuxnotxbh
  qcsnyvpigwzvrdawljfefotxbh
  qcsnyvpilkzmrdawljuefotxcz
  qcsnjvpigkzmrdawljuefoywbh
  qhsnyvpigyzmrdawljuhfotxbh
  qcsnyvpirkzmfdawljuffotxbh
  qcsjyvpigkzmvdawljuefotxzh
  qcszivpirkzmrdawljuefotxbh
  qwsnyvpigkzmtdawljuefetxbh
  qcrntvpigkzordawljuefotxbh
  qrsnyvpigkzmsdawljrefotxbh
  qcsnyviivkzmrdazljuefotxbh
  ecsnyvpigkzmrdawyjuefotxbw
  qnsnyvpkgkzmrdawljueqotxbh
  qcsyyppigkzmrdawljuefotxba
  qcsnyvpigkzhrdpwljuefouxbh
  ucsnyvpigkzmrdawojuefouxbh
  qysnyvpigkzmrdawljukfotxbd
  qcjnyvpigkzmrdalljfefotxbh
  fcsnyapigkmmrdawljuefotxbh
  qcnnkvpigkzmrdawljuefctxbh
  ocsnyvpigkzmsdawljuefotxbl
  qcsnyvpiakomrdawpjuefotxbh
  qcsnyvpigkzmrdawljvefbtxwh
  qcsnuvpigkzmvdfwljuefotxbh
  qcsnyapihkzmrdagljuefotxbh
  qzsnyvpigkzmrdawtjuefotxgh
  qcsnyvpigkzmrdawljuefomyah
  ocsnyvpigkzqrdawljuefotxbt
  qnsnyvpigkzmrdawljvevotxbh
  icsnyvpigkzmrdawljuefntxbt
  qcsnyvpigkzdrdawljuefotbbm
  scsnyvpigkzmrgawljuofotxbh
  qcsnydpigkzmrdowljuefotkbh
  qcsnyvtikkzmrdawljuefolxbh
  qcsiyvpigkcmrddwljuefotxbh
  qyrnyvpigkzmodawljuefotxbh
  pcsndvpfgkzmrdawljuefotxbh
  qcsnyvkigkhmriawljuefotxbh
  qcsnyvpigkzmsdmwlkuefotxbh
  dosnyvpigkzmrdawdjuefotxbh
  qcnnnvpigkzmrdzwljuefotxbh
  qcsnyvpivkumrdailjuefotxbh
  qcsnyvpigkzmrdswljuzfotxbz
  qcscynpigkzmrdawljuefotxbc
  qeanyvpigkzmrdawijuefotxbh
  qclnylpigkzmrdawljuefotxyh
  qcsnyvpigkzmrdawljbefowxbp
  qcsnyvpagkzmrdawljuefolebh
  qxsiyvpigkzmrdawljuefotxgh
  qcsnyvpigkynrdawljuefoqxbh
  qcsnevpigkzmrdxwgjuefotxbh
  qcsnyvpdgkzlrdawljeefotxbh
  qcsnyvpigkzmrgawljxbfotxbh
  ecsnyvpigkzmrdbwbjuefotxbh
  qcsnyvpigkzmraawujuefocxbh
  qcsnyvpihkzmrdawljuefouxbn
  fgsqyvpigkzmrdawljuefotxbh
  qcsnyvpigkmmrdawajuefotnbh
  qcsnyvvigkzmrdahljudfotxbh
  qcsnyvpixkzmrdqwljutfotxbh
  ncsnyvpickzmrdawljuehotxbh
  qcsnyvpizkzmrdawlpuefotxbp
  wcsnyvfigkzmrdakljuefotxbh
  qcsnyvpigkznrdhwljupfotxbh
  jcsnyvpigkpmzdawljuefotxbh
  qcsnyppigkkmrdawljujfotxbh
  qcsnyvpigkumrdaeljuefodxbh
  qcsnyvhigkzmrdrwljuefodxbh
  qcsnyvpigkacrdawtjuefotxbh
  qcsnyvpigkzmylawlquefotxbh
  """

  describe "checksum" do
    test "example" do
      input = """
      abcdef
      bababc
      abbcde
      abcccd
      aabcdd
      abcdee
      ababab
      """

      assert input
             |> String.split("\n", trim: true)
             |> Enum.map(&String.to_charlist/1)
             |> Inventory.checksum() == 12
    end

    test "puzzle input" do
      assert @input
             |> String.split("\n", trim: true)
             |> Enum.map(&String.to_charlist/1)
             |> Inventory.checksum() == 6422
    end
  end
end
