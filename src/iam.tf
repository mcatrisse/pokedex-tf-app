// Create IAM Role + Instance Profile if it doesn't exists

resource "aws_iam_instance_profile" "pokedex_instance_profile" {
  count = var.create_iam_role ? 1 : 0
  name = "PokedexInstanceProfile"
  role = aws_iam_role.pokedex_role[0].name
}

data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "cloudwatch_agent_server" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
data "aws_iam_policy" "ssm_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
 

resource "aws_iam_role_policy_attachment" "attach_cw_policy" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.pokedex_role[0].name
  policy_arn = data.aws_iam_policy.cloudwatch_agent_server.arn
}
resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.pokedex_role[0].name
  policy_arn = data.aws_iam_policy.ssm_instance.arn
}


resource "aws_iam_role" "pokedex_role" {
  count              = var.create_iam_role ? 1 : 0
  name               = "PokedexInstanceProfile"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
}