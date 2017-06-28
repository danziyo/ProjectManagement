CREATE PROCEDURE [dbo].[GetNewDJBM2]
@DJName varchar(20) ,
@QJM varchar(10) output,
@BM varchar(20) output,
@ResultOK Int output

 AS
Set @ResultOK=0

declare @Sql_Str varchar(500)
declare @TableName varchar(50)
declare @SCFS  varchar(20)
declare @BM_L Int
declare @QZ_L Int
declare @L Int
declare @K Int
declare @FDef Int
declare @BM_Max Int

Set @Sql_Str='Declare cur1 Cursor Global  For Select ���ɷ�ʽ,����,ǰ׺��+����, ���볤�� From ���ݱ� where  ��������='''+@DJName+''''
Exec(@Sql_Str)
Open cur1

Fetch Next From cur1 Into @SCFS,@TableName,@QJM,@BM_L
close cur1
deallocate cur1

Set @QZ_L=Len(@QJM)
Set @L=@QZ_L+@BM_L


IF @SCFS='������õ���+1' 
Begin

  IF (@TableName='���ϼƻ����˱�' ) or  (@TableName='���ϼӹ��ƻ����˱�' ) 
  Begin
    Set @Sql_Str='Declare cur2 Cursor Global For Select Max(Cast(SubString(�ƻ�����,'+Str(@QZ_L+1)+','+Str(@BM_L)+') As Int)) As MaxBH From '+@TableName+' where ����=0 And Len(RTrim(LTrim(�ƻ�����)))='+Str(@L)+' And Left(�ƻ�����,'+Str(@QZ_L)+')='''+@QJM+''' '
  End
  IF (@TableName='Ա����') or (@TableName='Ա����ٵ�')
  Begin
    Set @Sql_Str='Declare cur2 Cursor Global For Select Max(Cast(SubString(���뵥��,'+Str(@QZ_L+1)+','+Str(@BM_L)+') As Int)) As MaxBH From '+@TableName+' where ����=0 And Len(RTrim(LTrim(���뵥��)))='+Str(@L)+' And Left(���뵥��,'+Str(@QZ_L)+')='''+@QJM+''' '
  End
  IF  @TableName<>'���ϼƻ����˱�' 
  Begin
     IF  @TableName<>'���ϼӹ��ƻ����˱�' 
     Begin
         IF  (@TableName<>'Ա����') And (@TableName<>'Ա����ٵ�')
         Begin
            Set @Sql_Str='Declare cur2 Cursor Global For Select Max(Cast(SubString(��Ӧ����,'+Str(@QZ_L+1)+','+Str(@BM_L)+') As Int)) As MaxBH From '+@TableName+' where ����=0 And Len(RTrim(LTrim(��Ӧ����)))='+Str(@L)+' And Left(��Ӧ����,'+Str(@QZ_L)+')='''+@QJM+''' '
        End
     End
   End

  Exec(@Sql_Str)
  Open cur2
  Set @BM_Max=1
  Set @ResultOK=1

  Fetch Next From cur2  Into @BM_Max
  IF  (@@Fetch_Status=0) 
  Begin
     Set @BM_Max=@BM_Max+1
  End

  close cur2
  deallocate cur2

  Set @BM=LTrim(Str(@BM_Max))
  Set @L=Len(@BM)
  Set @BM=replicate('0',@BM_L-@L)+@BM

End

IF @SCFS='��Сδ�õ���'
Begin

  IF (@TableName='���ϼƻ����˱�' ) or  (@TableName='���ϼӹ��ƻ����˱�' ) 
  Begin
     Set @Sql_Str='Declare cur2 Cursor Global For Select Cast(SubString(�ƻ�����,'+Str(@QZ_L+1)+','+Str(@BM_L)+') As Int) As MaxBH From '+@TableName+' where ����=0 And Len(RTrim(LTrim(�ƻ�����)))='+Str(@L)+' And Left(�ƻ�����,'+Str(@QZ_L)+')='''+@QJM+''' order by �ƻ�����'
  End

  IF (@TableName='Ա����') or (@TableName='Ա����ٵ�')
  Begin
     Set @Sql_Str='Declare cur2 Cursor Global For Select Cast(SubString(���뵥��,'+Str(@QZ_L+1)+','+Str(@BM_L)+') As Int) As MaxBH From '+@TableName+' where ����=0 And Len(RTrim(LTrim(���뵥��)))='+Str(@L)+' And Left(���뵥��,'+Str(@QZ_L)+')='''+@QJM+''' order by ���뵥��'
  End
  IF  @TableName<>'���ϼƻ����˱�' 
  Begin
     IF  @TableName<>'���ϼӹ��ƻ����˱�' 
     Begin
        IF  (@TableName<>'Ա����') And (@TableName<>'Ա����ٵ�')
        Begin
            Set @Sql_Str='Declare cur2 Cursor Global For Select Cast(SubString(��Ӧ����,'+Str(@QZ_L+1)+','+Str(@BM_L)+') As Int) As MaxBH From '+@TableName+' where ����=0 And Len(RTrim(LTrim(��Ӧ����)))='+Str(@L)+' And Left(��Ӧ����,'+Str(@QZ_L)+')='''+@QJM+''' order by ��Ӧ����'
        End
    End
  End
 Exec(@Sql_Str)
Open cur2

Set @FDef=1
IF @BM<>'' 
Begin
Set @BM=Right(@BM,@BM_L)
  IF ISNUMERIC(@BM)=1
  Begin
    Set @FDef=cast(@BM as int) +1
  End
End


Set @BM=LTrim(Str(@FDef))
Set @L=Len(@BM)
Set @BM=replicate('0',@BM_L-@L)+@BM
Set @ResultOK=1

Fetch Next From cur2  Into @BM_Max
While (@@Fetch_Status=0) 
Begin
  IF @FDef>@BM_Max 
  Begin
    Fetch Next From cur2 Into @BM_Max
  End 
  Else IF @FDef=@BM_Max 
  Begin
    Set @FDef=@FDef+1
    Fetch Next From cur2 Into @BM_Max
  End
  Else IF @FDef<@BM_Max 
  Begin 
     break
  End
End

close cur2
deallocate cur2

Set @BM=LTrim(Str(@FDef))
Set @L=Len(@BM)
Set @BM=replicate('0',@BM_L-@L)+@BM
End